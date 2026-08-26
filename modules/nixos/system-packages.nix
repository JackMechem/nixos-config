{ pkgs, inputs, ... }:

{
    programs.firefox.enable = true;
    programs.hyprland.enable = true;

    # Unfree packages that require explicit permission
    nixpkgs.config.allowUnfreePredicate =
        pkg:
        builtins.elem (pkgs.lib.getName pkg) [
            "diskdigger"
        ];

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
        inputs.diskdigger.packages.${pkgs.system}.diskdigger
    ];

    # Yubikey support services
    services.udev.packages = [ pkgs.yubikey-personalization ];
    services.pcscd.enable = true;
    programs.ssh.startAgent = true;
}
