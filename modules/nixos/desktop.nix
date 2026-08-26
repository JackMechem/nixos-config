{ pkgs, ... }:

{
    # --- Display Manager & Desktop Environment ---
    services.displayManager.gdm.enable = true;
    services.desktopManager.plasma6.enable = true;

    # --- Desktop Integration ---
    programs.thunar.enable = true;
    programs.dconf.enable = true;
    services.dbus.enable = true;
    services.libinput.enable = true;
    services.gvfs.enable = true;       # virtual filesystem (MTP, SMB, trash, etc.)
    services.gtkbar.enable = true;

    # --- XDG Portals ---
    # Portals allow sandboxed apps to access desktop features
    xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = with pkgs; [
            xdg-desktop-portal-gtk
            xdg-desktop-portal-hyprland
            xdg-desktop-portal-gnome
        ];
    };
}
