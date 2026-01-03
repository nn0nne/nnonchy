# mime-ext.yazi

A [Yazi](https://github.com/sxyazi/yazi) plugin that quickly get mimetype to improved theme rendering speed

> [!NOTE]
> The latest main branch of Yazi is required at the moment.


## Installation

```sh
# Linux/macOS
git clone https://gitee.com/DreamMaoMao/mime-ext.yazi.git ~/.config/yazi/plugins/mime-ext.yazi

# Windows
git clone https://gitee.com/DreamMaoMao/mime-ext.yazi.git %AppData%\yazi\config\plugins\mime-ext.yazi
```
Add this to ~/.config/yazi/yazi.toml, `below the exists [plugin] modules`, like this
```
[plugin]

[[plugin.prepend_fetchers]]
id   = "mime"
if   = "!(mime|dummy)"
name = "*"
run  = "mime-ext"
prio = "high"
```

# config
```lua
require("mime-ext"):setup {
	-- Expand the existing filename database (lowercase), for example:
	-- with_files = {
	-- 	makefile = "text/makefile",
	-- 	-- ...
	-- },

	fallback_file1 = true,
}
```