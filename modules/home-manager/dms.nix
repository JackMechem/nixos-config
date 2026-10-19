{ inputs, ... }:
{
    imports = [
        inputs.dms.homeModules.dank-material-shell
    ];

    # DankMaterialShell: bar, launcher, notifications, control center, settings.
    # Settings are left unmanaged so the DMS settings GUI can write them.
    programs.dank-material-shell = {
        enable = true;
        systemd = {
            enable = true;
            # Only start inside Hyprland, not in the Plasma session
            target = "hyprland-session.target";
        };
    };
}
