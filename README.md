# dotfiles

Personal NixOS configuration with Hyprland. Designed to be modular, easy to maintain, and configured from a single place (`vars.nix`).

---

## Overview

- **OS:** NixOS (Flakes + Home Manager)
- **WM:** Hyprland (configured via Lua modules)
- **Bar & Shell:** Wayle (status bar, notifications, control center)
- **Terminal:** Kitty + Fish shell + Starship prompt
- **File Manager:** Dolphin (configured with standalone Qt6 dark theme & thumbnailers)
- **App Launcher:** Rofi
- **System Helper:** `nh` (Nix Helper) for fast builds, visual progress, and clean diffs

---

## Configuration (`vars.nix`)

All variables, colors, user profile settings, and hardware options live in [`vars.nix`](file:///home/luther/dotfiles/vars.nix). You shouldn't need to dig into system files to change basic parameters:

```nix
{
  username = "luther";
  hostname = "nixos";

  # GPU driver: "nvidia" | "amd" | "intel" | "vm"
  gpuDriver = "nvidia";

  # Default apps
  terminal = "kitty";
  browser = "firefox";
  fileManager = "dolphin";
  editor = "zeditor";

  # Theming: "pure-monochrome" (strict black/white) | "muted-pastel" (soft accents)
  themePreset = "pure-monochrome";

  # UI Settings
  font = "JetBrainsMono Nerd Font";
  fontSize = 12;
  rounding = 10;
  borderSize = 2;
  mouseSensitivity = 0.75;
}
```

---

## Managing the System (`nh`)

System management commands are shortened in Fish using `nh`:

```bash
nr        # Rebuild and apply changes (nh os switch)
nrt       # Test changes without writing to bootloader (nh os test)
nc        # Clean old generations, keep latest 3 (nh clean all --keep 3)
nfu       # Update flake inputs (nix flake update)
```

> **First-time installation note:** Run `sudo nixos-rebuild switch --flake /home/<user>/dotfiles#nixos` once. After that, `nr` works from anywhere.

---

## Keybindings

| Key | Action |
|---|---|
| `Super + Space` / `Super` (tap) | Rofi application launcher |
| `Super + /` | Interactive shortcuts cheatsheet |
| `Ctrl + Alt + Delete` | Task manager (`btop` floating) |
| `Super + Return` / `Super + T` | Terminal (`kitty`) |
| `Super + W` | Web browser |
| `Super + E` | File manager (`dolphin`) |
| `Super + C` | Code editor |
| `Super + V` | Clipboard history |
| `Super + A` | Wayle control center |
| `Super + Shift + W` | Wallpaper picker |
| `Super + Escape` | Power menu (lock / reboot / poweroff) |
| `Super + Q` | Close active window |
| `Super + F` | Toggle floating mode |
| `Super + M` | Toggle fullscreen mode |
| `Super + 1..0` | Switch to workspace 1..10 |
| `Super + Alt + 1..0` | Move active window to workspace silently |
| `Print` / `Super + Shift + S` | Screenshot selected area (`slurp` + `grim`) |
| `Shift + Print` | Fullscreen screenshot |
| `Super + Alt + R` | Screen recording (selected area) |
| `Super + Ctrl + R` | Screen recording with audio |

---

## Repository Structure

```
.
├── flake.nix                          # Flake inputs & system outputs
├── flake.lock                         # Locked dependency pins
├── vars.nix                           # Centralized variables & rice parameters
├── hosts/
│   ├── common/                        # Shared system modules
│   │   ├── hardware/                  # Modular GPU drivers (NVIDIA, AMD, Intel, VM)
│   │   │   ├── amd.nix
│   │   │   ├── default.nix
│   │   │   ├── intel.nix
│   │   │   ├── nvidia.nix
│   │   │   └── vm.nix
│   │   ├── sddm/                      # Standalone Qt6 SDDM configuration
│   │   │   ├── default.nix
│   │   │   └── theme.conf.user
│   │   ├── audio.nix                  # PipeWire sound setup
│   │   ├── core.nix                   # Boot, locale, nh helper, auto-maintenance
│   │   ├── default.nix                # Common modules aggregator
│   │   ├── hyprland.nix               # System-level Hyprland, SDDM, polkit
│   │   └── users.nix                  # User account parameterized via vars.nix
│   └── nixos/                         # Host-specific configuration
│       ├── default.nix
│       └── hardware-configuration.nix
└── home/
    └── luther/                        # Home Manager configuration
        ├── bar/
        │   └── wayle/                 # Wayle bar & control center configs
        │       ├── config/config.toml
        │       └── default.nix
        ├── launcher/
        │   └── rofi/                  # Rofi styles, color themes, wallpaper picker
        │       ├── colors.rasi
        │       ├── config.rasi
        │       ├── default.nix
        │       └── wallpaper.rasi
        ├── media/                     # Helper scripts & media tools
        │   ├── scripts/
        │   │   ├── airplane-mode.sh
        │   │   ├── change-wall.sh
        │   │   ├── cheatsheet.sh
        │   │   ├── find-files.sh
        │   │   ├── powermenu.sh
        │   │   ├── record.sh
        │   │   ├── screenshot.sh
        │   │   └── search.sh
        │   └── default.nix
        ├── shell/                     # Shell configuration & CLI tools
        │   ├── fastfetch/             # Fastfetch config & ASCII logo
        │   │   ├── config.jsonc
        │   │   └── logo.txt
        │   ├── fish.nix               # Fish aliases & nh helpers
        │   └── tools.nix              # CLI utilities (git, bat, btop, eza, etc.)
        ├── terminal/
        │   ├── kitty/                 # Kitty terminal config & color templates
        │   │   ├── colors.conf
        │   │   ├── default.nix
        │   │   └── kitty.conf
        │   ├── micro/                 # Micro terminal editor config & theme
        │   │   ├── colorschemes/custom-dark.micro
        │   │   ├── default.nix
        │   │   └── settings.json
        │   └── starship/              # Starship prompt configuration
        │       ├── default.nix
        │       └── starship.toml
        ├── themes/                    # Theming, fonts, icons & cursors
        │   ├── matugen/               # Matugen templates (dormant/reusable)
        │   │   ├── templates/
        │   │   ├── config.toml
        │   │   └── default.nix
        │   ├── default.nix            # GTK/Qt themes, Breeze & Tela icons
        │   ├── dolphinrc              # Dolphin thumbnailers & UI settings
        │   └── kdeglobals             # Centralized KDE dark color scheme
        ├── wm/
        │   └── hyprland/              # Hyprland window manager setup
        │       ├── lua/               # Lua configuration modules
        │       │   ├── animations.lua
        │       │   ├── autostart.lua
        │       │   ├── colors.lua
        │       │   ├── decoration.lua
        │       │   ├── env.lua
        │       │   ├── general.lua
        │       │   ├── init.lua
        │       │   ├── keybinds.lua
        │       │   ├── monitors.lua
        │       │   ├── rules.lua
        │       │   └── vars.lua
        │       ├── default.nix        # Hyprland HM module & Lua bridge
        │       ├── hypridle.conf      # Idle management
        │       └── hyprlock.conf      # Lock screen config
        └── default.nix                # Home Manager entrypoint
```

---

## Adding a New Machine

1. Update `hostname`, `username`, and `gpuDriver` in `vars.nix`.
2. Generate hardware config:
   ```bash
   nixos-generate-config --show-hardware-config > hosts/<hostname>/hardware-configuration.nix
   ```
3. Create `hosts/<hostname>/default.nix` importing `../common` and `./hardware-configuration.nix`.
4. Apply with `nr` (or `sudo nixos-rebuild switch --flake .#<hostname>`).
