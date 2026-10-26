local M = {}

-- ─────────────────────────────────────────────────────────────
--  CONFIGURATION
--  Adjust these values as needed
-- ─────────────────────────────────────────────────────────────

-- Maximum video file size (in bytes)
-- Files above this limit will be skipped without spawning ffmpeg
-- Default: 500MB = 500 * 1024 * 1024
local MAX_FILE_SIZE = 500 * 1024 * 1024

-- ffprobe timeout in seconds
-- If ffprobe doesn't complete within this time, it's considered failed
local FFPROBE_TIMEOUT = 5

-- Grid thumbnail: tile layout and scale
-- "2x2" = 4 frames, scale 400px width
local TILE_LAYOUT   = "2x2"
local SCALE_WIDTH   = 400
local FRAME_COUNT   = 4

-- Show `mediainfo` output below the grid
local SHOW_METADATA = true

-- Maximum fraction of the preview height reserved for metadata (tunable)
local METADATA_MAX_RATIO = 0.5

-- Cache file suffixes
-- yazi runs *every* matching preloader, and the built-in `video` preloader
-- writes a single frame to the plain cache path. Use our own suffixes so the
-- two can never clobber each other (same idea as mediainfo's `_mediainfo`).
local CACHE_SUFFIX = ".grid"
local INFO_SUFFIX  = ".info"

local function cache_url(job, suffix)
    local cache = ya.file_cache(job)
    return cache and Url(tostring(cache) .. suffix)
end

local function grid_cache(job) return cache_url(job, CACHE_SUFFIX) end
local function info_cache(job) return cache_url(job, INFO_SUFFIX) end

-- ─────────────────────────────────────────────────────────────
--  PEEK: Display cached thumbnail (grid on top, metadata below)
-- ─────────────────────────────────────────────────────────────
function M:peek(job)
    local cache = grid_cache(job)
    if not cache then
        return
    end

    -- Run preload and surface its error (if any) as a widget,
    -- then draw the cached image.
    local ok, err = self:preload(job)
    if not ok or err then
        return ya.preview_widget(job, err)
    end

    -- Split the preview area: grid image on top, metadata text below.
    local info = SHOW_METADATA and self:read_info(job) or nil
    local meta_h = info
            and math.min(math.floor(job.area.h * METADATA_MAX_RATIO), job.area.h - 1)
        or 0
    local grid_h = job.area.h - meta_h

    -- `ya.image_show` returns (rect, err): err is nil on success,
    -- or an Error userdata that `preview_widget` renders as text.
    local _, image_err = ya.image_show(cache, ui.Rect {
        x = job.area.x,
        y = job.area.y,
        w = job.area.w,
        h = grid_h,
    })
    if image_err then
        return ya.preview_widget(job, image_err)
    end

    if meta_h > 0 then
        ya.preview_widget(job, ui.Text.parse(info):area(ui.Rect {
            x = job.area.x,
            y = job.area.y + grid_h,
            w = job.area.w,
            h = meta_h,
        }):wrap(ui.Wrap.NO))
    else
        ya.preview_widget(job, nil)
    end
end

-- Read the cached `mediainfo` text for this file, if any.
function M:read_info(job)
    local cache = info_cache(job)
    if not cache then
        return nil
    end

    local f = io.open(tostring(cache), "r")
    if not f then
        return nil
    end
    local content = f:read("*all")
    f:close()
    return content ~= "" and content or nil
end

function M:seek(job) end

-- ─────────────────────────────────────────────────────────────
--  PRELOAD: Generate thumbnail + metadata
--  Returns (complete: boolean, err: Error?) as required by yazi >= 26.x
-- ─────────────────────────────────────────────────────────────
function M:preload(job)
    local _, info_err = self:preload_info(job)
    if info_err then
        -- Metadata is optional: log the failure but still show the grid.
        ya.err(tostring(info_err))
    end
    return self:preload_grid(job)
end

-- Generate the `mediainfo` text cache for this file.
function M:preload_info(job)
    if not SHOW_METADATA then
        return true
    end

    local cache = info_cache(job)
    if not cache then
        return true
    end
    local cha = fs.cha(cache)
    if cha and cha.len > 0 then
        return true  -- cache hit
    end

    local output, err = Command("mediainfo"):arg(tostring(job.file.url)):output()
    if not output then
        return true, Err("[video-grid] failed to start `mediainfo`: %s", tostring(err))
    elseif not output.status.success then
        return true, Err(
            "[video-grid] `mediainfo` exited with code %s",
            tostring(output.status.code)
        )
    end

    return fs.write(cache, output.stdout)
end

-- Generate the 2x2 grid thumbnail cache for this file.
function M:preload_grid(job)

    -- ── Skip if this job is a re-trigger ──────────
    -- job.skip > 0 means yazi has already triggered this preload
    -- and the result is still pending. No need to spawn again.
    if job.skip > 0 then
        return true
    end

    -- ── Skip files above size limit ───────────────
    -- job.file.cha.len is the file size in bytes
    -- This is zero-cost, no additional syscalls needed
    local file_size = job.file.cha and job.file.cha.len or 0
    if file_size > MAX_FILE_SIZE then
        return true, Err(
            "[video-grid] SKIP (size): %s — %.0f MB exceeds limit %.0f MB",
            tostring(job.file.url),
            file_size / 1024 / 1024,
            MAX_FILE_SIZE / 1024 / 1024
        )
    end

    -- ── Skip if cache exists ────────────────────
    -- Only treat a non-empty cache file as a hit: a zero-length file
    -- means a previous ffmpeg run failed partway through.
    local cache = grid_cache(job)
    if not cache then
        return true
    end
    local cha = fs.cha(cache)
    if cha and cha.len > 0 then
        return true  -- cache hit, immediate success return
    end

    -- ── Start thumbnail generation process ─────────────────────
    -- Probe video duration to calculate grid fps
    -- Timeout to avoid hangs on corrupt or unreadable files
    local probe = Command("ffprobe")
        :arg("-i"):arg(tostring(job.file.url))
        :arg("-show_entries"):arg("format=duration")
        :arg("-v"):arg("quiet")
        :arg("-of"):arg("csv=p=0")
        :arg("-timeout"):arg(tostring(FFPROBE_TIMEOUT * 1000000))  -- in microseconds
        :stdout(Command.PIPED)
        :output()

    local duration = probe and probe.stdout and tonumber(probe.stdout)

    if not duration or duration <= 0 then
        return true, Err(
            "[video-grid] ERROR ffprobe: %s — output: %s",
            tostring(job.file.url),
            tostring(probe and probe.stdout)
        )
    end

    -- Calculate fps to produce exactly FRAME_COUNT frames
    -- evenly distributed across video duration
    local fps_val = FRAME_COUNT / duration
    local filter_string = string.format(
        "fps=%f,scale=%d:-1,tile=%s",
        fps_val, SCALE_WIDTH, TILE_LAYOUT
    )

    -- Spawn ffmpeg to generate thumbnail grid
    local child, err_code = Command("ffmpeg")
        :arg("-v"):arg("quiet")
        :arg("-y")                                      -- overwrite cache if exists
        :arg("-nostdin")                                -- non-interactive
        :arg("-i"):arg(tostring(job.file.url))
        :arg("-vf"):arg(filter_string)
        :arg("-frames:v"):arg("1")                     -- only 1 frame output (grid)
        :arg("-q:v"):arg("3")                           -- JPG quality (1=best, 31=worst)
        :arg("-f"):arg("image2")
        :arg("-c:v"):arg("mjpeg")
        :arg(tostring(cache))
        :spawn()

    if not child then
        return true, Err(
            "[video-grid] ERROR spawn ffmpeg: %s — code: %s",
            tostring(job.file.url),
            tostring(err_code)
        )
    end

    -- Wait for ffmpeg to complete
    local status = child:wait()

    if status and status.success then
        return true  -- success, cache ready to display
    else
        -- failed, yazi will retry according to bizarre_retry
        return false, Err(
            "[video-grid] ERROR ffmpeg exit: %s — status: %s",
            tostring(job.file.url),
            tostring(status and status.code)
        )
    end
end

return M
