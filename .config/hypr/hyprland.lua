-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Disable all Omarchy default bindings. Add your own in hypr/bindings.lua.
-- omarchy_default_bindings = false
--
-- Or disable only bindings for Omarchy's preinstalled apps/web apps while
-- keeping core window-manager bindings:
-- omarchy_preinstalled_bindings = false

-- Load Omarchy defaults.
require("default.hypr.omarchy")

-- Put your personal overrides in these files. They're loaded after Omarchy's
-- defaults so package updates can improve the defaults without rewriting your
-- ~/.config/hypr files.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- Add any other personal Hyprland configuration below.
-- o.window("qemu", { workspace = "5" })

-- Float Enpass on open.
o.window("Enpass", { float = true, center = true, size = { 900, 600 } })

-- Float Zed's Settings window (opened via Ctrl+,).
o.window({ class = "^dev\\.zed\\.Zed$", initial_title = "^Zed — Settings$" }, {
  float = true,
  center = true,
  size = { 900, 700 },
})

-- Float Mozc's dictionary tool (opened via SUPER+SHIFT+D).
o.window("^mozc_tool$", { float = true, center = true, size = { 700, 500 } })

-- Float Nautilus (file manager) windows.
o.window("^org\\.gnome\\.Nautilus$", { float = true, center = true, size = { 1000, 650 } })
