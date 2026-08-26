{
    config,
    lib,
    pkgs,
    inputs,
    ...
}:

{
    imports = [
        ./hardware-configuration.nix
        inputs.home-manager.nixosModules.default

        # --- Desktop UI ---
        ../../modules/nixos/desktop.nix          # display manager, plasma6, xdg portals
        ../../modules/nixos/gtkapps.nix
        ../../modules/nixos/gtkbar.nix
        ../../modules/nixos/fonts.nix

        # --- Hardware ---
        ../../modules/nixos/bluetooth.nix

        # --- Gaming ---
        ../../modules/nixos/steam.nix

        # --- System Services ---
        ../../modules/nixos/sound.nix
        ../../modules/nixos/print.nix
        ../../modules/nixos/syncthing.nix
        ../../modules/nixos/ollama.nix

        # --- Users & Auth ---
        ../../modules/nixos/user-jack.nix

        # --- Packages ---
        # Add system packages in system-packages.nix
        ../../modules/nixos/system-packages.nix
    ];

    # --- Boot ---
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_6;

    # --- Networking ---
    networking.hostName = "jackdesk";
    networking.networkmanager.enable = true;
    networking.nameservers = [ "192.168.1.164" ];
    networking.firewall.allowedTCPPorts = [
        2200
        3000
    ];

    # --- Nix Settings ---
    nix.settings.experimental-features = [
        "nix-command"
        "flakes"
    ];
    nixpkgs.config.allowUnfree = true;

    # --- Locale ---
    time.timeZone = "America/Los_Angeles";

    # --- Core Programs ---
    programs.zsh.enable = true;
    programs.nix-ld.enable = true;  # run unpatched binaries

    # --- Virtualisation ---
    virtualisation.docker.enable = true;

    # --- Hardware ---
    hardware.xpadneo.enable = true;  # Xbox controller driver

    # --- Services ---
    services.openssh.enable = true;
    services.input-remapper.enable = true;

    # --- Home Manager ---
    home-manager = {
        extraSpecialArgs = { inherit inputs; };
        users."jack" = import ./home.nix;
    };

    system.stateVersion = "25.11";
}
