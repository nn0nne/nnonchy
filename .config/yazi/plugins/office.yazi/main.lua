--- @since 26.9.1
-- Patched from macydnah/office.yazi@41ebef8 (MIT) for Yazi 26.x:
--   * ya.preview_widgets / ya.manager_emit / ya.mgr_emit no longer exist
--   * each conversion gets its own LibreOffice profile, see M:doc2pdf
--   * scrolling past the last page stops there instead of erroring

local M = {}

function M:peek(job)
	local start, cache = os.clock(), ya.file_cache(job)
	if not cache then
		return
	end

	local ok, err, bound = self:preload(job)
	if bound and bound > 0 then
		return ya.emit("peek", { bound - 1, only_if = job.file.url, upper_bound = true })
	elseif not ok or err then
		return ya.preview_widget(job, err)
	end

	ya.sleep(math.max(0, rt.preview.image_delay / 1000 + start - os.clock()))
	local _, err = ya.image_show(cache, job.area)
	ya.preview_widget(job, err)
end

function M:seek(job)
	local h = cx.active.current.hovered
	if h and h.url == job.file.url then
		local step = ya.clamp(-1, job.units, 1)
		ya.emit("peek", { math.max(0, cx.active.preview.skip + step), only_if = job.file.url })
	end
end

-- Converts page `job.skip + 1` to a PDF inside `dir`.
-- Yazi preloads every visible office file at once, and concurrent `libreoffice`
-- runs sharing the default profile randomly exit 1 without writing a PDF, so each
-- run gets a private profile in `dir`. That also keeps it clear of an open
-- LibreOffice window. A fresh profile costs ~0.25s.
function M:doc2pdf(job, dir)
	--[[	For Future Reference: Regarding `libreoffice` as preconverter
	  1. It prints errors to stdout (always, doesn't matter if it succeeded or it failed)
	  2. Always writes the converted files to the filesystem, so no "Mario|Bros|Piping|Magic" for the data stream (https://ask.libreoffice.org/t/using-convert-to-output-to-stdout/38753)
	  3. The `pdf:draw_pdf_Export` filter needs literal double quotes when defining its options (https://help.libreoffice.org/latest/en-US/text/shared/guide/pdf_params.html?&DbPAR=SHARED&System=UNIX#generaltext/shared/guide/pdf_params.xhp)
	  3.1 Regarding double quotes and Lua strings, see https://www.lua.org/manual/5.1/manual.html#2.1 --]]
	local output, err = Command("libreoffice")
		:arg({
			"-env:UserInstallation=file://" .. tostring(dir:join("profile")),
			"--headless",
			"--convert-to",
			'pdf:draw_pdf_Export:{"PageRange":{"type":"string","value":"' .. job.skip + 1 .. '"}}',
			"--outdir",
			tostring(dir),
			tostring(job.file.path),
		})
		:stdin(Command.NULL)
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:output()

	if not output then
		return nil, Err("Failed to start `libreoffice`, error: %s", err)
	end

	local pdf = dir:join((job.file.name:match("^(.+)%.[^.]+$") or job.file.name) .. ".pdf")
	if not output.status.success or not fs.cha(pdf) then
		local msg = (output.stdout .. output.stderr):match("Error:? [^\n]+") or "Unknown error"
		return nil, Err("Failed to preconvert `%s` to a temporary PDF: %s", job.file.name, msg)
	end

	return pdf
end

function M:preload(job)
	local cache = ya.file_cache(job)
	if not cache or fs.cha(cache) then
		return true
	end

	local base = Url(string.format("/tmp/yazi-%d/office.yazi", ya.uid()))
	fs.create("dir_all", base)
	-- A preview cancelled mid-conversion (hovering away) never reaches the cleanup
	-- below and leaves a ~300K profile behind, so sweep up anything stale
	for _, f in ipairs(fs.read_dir(base, {}) or {}) do
		local cha = fs.cha(f.url) -- read_dir leaves mtime nil
		if cha and cha.mtime and cha.mtime < os.time() - 600 then
			fs.remove("dir_all", f.url)
		end
	end
	local dir, err = fs.unique("dir", base:join(ya.hash(tostring(job.file.url))))
	if not dir then
		return true, Err("Failed to create a temporary directory, error: %s", err)
	end

	local pdf, err = self:doc2pdf(job, dir)
	if not pdf then
		fs.remove("dir_all", dir)
		-- LibreOffice can't export a page past the end, so when scrolling fails
		-- the previous page was the last one
		return true, err, job.skip > 0 and job.skip or nil
	end

	local output, err = Command("pdftoppm")
		:arg({
			"-singlefile",
			"-jpeg",
			"-jpegopt",
			"quality=" .. rt.preview.image_quality,
			"-f",
			1,
			tostring(pdf),
		})
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:output()

	fs.remove("dir_all", dir)

	if not output then
		return true, Err("Failed to start `pdftoppm`, error: %s", err)
	elseif not output.status.success then
		return true, Err("Failed to convert %s to image, stderr: %s", job.file.name, output.stderr)
	end

	return fs.write(cache, output.stdout)
end

return M
