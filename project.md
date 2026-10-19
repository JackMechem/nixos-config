# NixOS Config

Flake-based NixOS + home-manager config for all my machines.

## Hosts

| Flake target | Hostname | Machine | Desktop |
|---|---|---|---|
| `desktop` | `jackdesk` | Main desktop, 3 monitors | Hyprland + DankMaterialShell, Plasma 6 as fallback |
| `t480` | `t480` | ThinkPad T480 | Hyprland + DankMaterialShell, Plasma 6 as fallback |
| `dellserv` | `dell-xps-nixos-serv` | Home server (Jellyfin, Filebrowser, Syncthing) | Headless |

Rebuild:

```sh
sudo nixos-rebuild switch --flake ~/nixos#desktop   # or #t480, #dellserv
```

Test a build without switching:

```sh
nixos-rebuild build --flake ~/nixos#desktop
```

## Layout

```
flake.nix                  inputs + one nixosConfiguration per host
hosts/<host>/
  configuration.nix        system config; imports modules/nixos/*
  hardware-configuration.nix
  home.nix                 home-manager config; imports modules/home-manager/*
modules/nixos/             system modules (desktop, sound, print, bluetooth, steam, ...)
modules/home-manager/      user modules (hyprland, dms, zsh, tmux, ghostty, packages, ...)
```

- System packages go in `modules/nixos/system-packages.nix`.
- User packages go in `modules/home-manager/homepackages.nix`.

## Desktop stack

- **Login:** GDM. Pick Hyprland or Plasma at login.
- **Compositor:** Hyprland, configured in Nix via home-manager.
  - `modules/home-manager/hyprland-desktop.nix`: monitors, workspaces, keybinds. Used by both `desktop` and `t480`.
    Written in Hyprland's Lua format (`configType = "lua"`, generates `~/.config/hypr/hyprland.lua`).
    Validate a build with `Hyprland --verify-config -c <generated hyprland.lua>`.
  - `modules/home-manager/hyprland.nix`: older laptop config with hyprlock/hypridle. Not imported by any host right now.
- **Shell:** DankMaterialShell (`modules/home-manager/dms.nix`). Provides the bar, launcher, notifications, control center, wallpaper, lock screen, clipboard and polkit agent.
  - Runs as the `dms` systemd user service, bound to `hyprland-session.target`, so it only starts in Hyprland and not in Plasma.
  - Settings are not managed in Nix. They live in `~/.config/DankMaterialShell/` so the DMS settings GUI (Super+,) can edit them.
  - Pinned to a release tag in `flake.nix`. To upgrade, change the tag and run `nix flake lock --update-input dms`.
  - Don't run `dms setup`. It writes its own Hyprland config and would override the Nix-generated one.
  - `hyprland.lua` loads the DMS fragments `dms.layout`, `dms.cursor`, `dms.windowrules`, `dms.colors`, `dms.binds` and `dms.binds-user` from `~/.config/hypr/dms/` (written by the DMS settings GUI), so those settings pages work. `dms.outputs` is deliberately not loaded: monitors (10-bit) stay in Nix. DMS cannot add `require` lines itself because `hyprland.lua` is read-only, so a new DMS page needs its line added in Nix.
- **Fallback:** Plasma 6 (`modules/nixos/desktop.nix`).

## Keybinds (Hyprland)

`SUPER` is the main modifier.

| Keys | Action |
|---|---|
| Super+Return / Super+Shift+Return | Terminal (ghostty) / floating terminal |
| Super+Q | Close window |
| Super+Space | DMS launcher |
| Super+` | hyprmwh window menu |
| Super+W | Browser (zen-twilight) |
| Super+E / Super+Shift+E | Thunar / floating Thunar |
| Super+H/J/K/L | Move focus |
| Super+Shift+H/J/K/L | Move window |
| Super+Alt+H/J/K/L | Resize window |
| Super+1..0, Super+Alt+1/2 | Workspaces 1-12 |
| Super+Shift+(same) | Move window to that workspace |
| Super+O / Super+Shift+O | Special workspace / move window to it |
| Super+Tab | Toggle floating |
| Super+V | Toggle split |
| Super+P | Pseudotile |
| Super+F / Super+M | Fullscreen / maximize |
| Super+Escape | Focus previous window |
| Super+B | Toggle DMS bar |
| Super+, | DMS settings |
| Super+N | Notifications |
| Super+Shift+V | Clipboard history |
| Super+X | Power menu |
| Super+Shift+D | Lock |
| Super+Shift+/ | Keybind cheatsheet |
| Super+Shift+P | Restart DMS |
| Super+Shift+S | Screenshot area (DMS; saves to ~/Pictures/Screenshots + clipboard) |
| Super+Home | Emoji picker (wofi-emoji) |
| Super+- | Toggle HDMI-A-1 on/off (desktop) |
| Ctrl+Alt+Delete | Process list |
| Media / volume keys | DMS audio and media controls, with an on-screen popup |

## Desktop monitor layout

| Output | Mode | Position | Workspaces |
|---|---|---|---|
| HDMI-A-1 | 1920x1080@60 | left | 11-12 |
| DP-1 | 2560x1440@144 | center (main) | 1-5 |
| DP-2 | 1920x1080@75 | right | 6-10 |

## Remotes

- `origin`: Forgejo on the home server (primary).
- `public`: GitHub mirror. This remote is **public**, so don't commit secrets.

## Known issues / TODO

- `t480` imports `hyprland-desktop.nix`, which has the desktop's 3-monitor layout instead of the laptop's `eDP-1`. `hyprland.nix` looks like the intended laptop config.
- `solaar -w hide` autostarts in Hyprland, but solaar isn't installed.
- There are evaluation warnings about deprecated `pkgs.system`; it should be replaced with `pkgs.stdenv.hostPlatform.system`.
