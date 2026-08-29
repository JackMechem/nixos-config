{ pkgs, inputs, ... }:

{
    programs.firefox.enable = true;
    programs.hyprland.enable = true;

    environment.systemPackages = with pkgs; [

        # ===== Core Utilities =====
        tree
        vim
        wget
        git
        gcc
        unzip
        killall

        # ===== Shell / Terminal =====
        fastfetch

        # ===== System Tools =====
        brightnessctl
        cryptsetup
        input-remapper

        # ===== Runtimes =====
        python3
        nodejs

        # ===== Security / Authentication =====
        yubikey-manager
        yubioath-flutter
        kdePackages.polkit-kde-agent-1

        # ===== Flake Packages =====
        # To add a new flake package: add the input to flake.nix, then reference it here
        inputs.rust-app-menu.packages.${pkgs.system}.default
    ];

    # Yubikey support services
    services.udev.packages = [ pkgs.yubikey-personalization ];
    services.pcscd.enable = true;
    programs.ssh.startAgent = true;
}
