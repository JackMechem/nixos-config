# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
    config,
    lib,
    pkgs,
    inputs,
    ...
}:

{
    imports = [
        # Include the results of the hardware scan.
        ./hardware-configuration.nix
        inputs.home-manager.nixosModules.default
        ../../modules/nixos/user-jack.nix
        ../../modules/nixos/syncthingServer.nix
        ../../modules/nixos/yubikey-auth.nix
    ];

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "dell-xps-nixos-serv"; # Define your hostname.
    networking.networkmanager.enable = true;
    networking.hosts = {
        "127.0.0.1" = [ "gitssh.jackmechem.dev" ];
    };
    networking.firewall.allowedTCPPorts = [
        80
        3000
        8384
        8080
        443
        22
        53
    ];
    networking.firewall.allowedUDPPorts = [ 53 ];

    nix.settings.experimental-features = [
        "nix-command"
        "flakes"
    ];

    time.timeZone = "America/Los_Angeles";

    services.dbus.enable = true;

    programs.zsh.enable = true;

    programs.dconf.enable = true;

    nixpkgs.config.allowUnfree = true;

    services.openssh.enable = true;

    services.openssh.settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
    };

    ##  services.nginx = {
    ##      enable = true;
    ##      virtualHosts."your.domain.or.ip" = {
    ##        locations."/" = {
    ##          proxyPass = "http://127.0.0.1:3000";
    ##          proxyWebsockets = true;
    ##        };
    ##      };
    ##  };

    boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 0;
    home-manager = {
        extraSpecialArgs = { inherit inputs; };
        users = {
            "jack" = import ./home.nix;
        };
    };

    services.cloudflare-dyndns = {
        enable = true;
        apiTokenFile = "/etc/secrets/cloudflare-dyndns";
        domains = [ "server.jackmechem.dev" ];
        proxied = true;
        ipv4 = true;
        ipv6 = false;
    };

    systemd.services.caddy.serviceConfig.EnvironmentFile = "/etc/secrets/caddy-env";

    services.caddy = {
        enable = true;
        package = pkgs.caddy.withPlugins {
            plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
            hash = "sha256-Olz4W84Kiyldy+JtbIicVCL7dAYl4zq+2rxEOUTObxA=";
        };
        globalConfig = ''
            acme_dns cloudflare {env.CLOUDFLARE_API_TOKEN}
        '';
        virtualHosts."dashboard.jackmechem.dev" = {
            extraConfig = ''
                reverse_proxy localhost:3000
            '';
        };
        virtualHosts."syncthing.jackmechem.dev" = {
            extraConfig = ''
                reverse_proxy localhost:8384 {
                  header_up Host {upstream_hostport}
                }
            '';
        };
        virtualHosts."git.jackmechem.dev" = {
            extraConfig = ''
                reverse_proxy localhost:3002
            '';
        };
        virtualHosts."adguard.jackmechem.dev" = {
            extraConfig = ''
                reverse_proxy localhost:3003
            '';
        };
    };

    services.server-dash = {
        enable = true;
        package = "/var/lib/server-dash/build";
    };
    services.server-dash-api = {
        enable = true;
        useNixBuild = false;
    };

    services.resolved.settings.Resolve.DNSStubListener = "no";

    services.adguardhome = {
        enable = true;
        mutableSettings = false;
        port = 3003;
        settings = {
            http.address = lib.mkForce "127.0.0.1:3003";
            dns = {
                bind_hosts = [ "0.0.0.0" ];
                port = 53;
                bootstrap_dns = [
                    "9.9.9.10"
                    "149.112.112.10"
                ];
            };
        };
    };

    services.forgejo = {
        enable = true;
        settings = {
            server = {
                DOMAIN = "git.jackmechem.dev";
                HTTP_PORT = 3002;
                ROOT_URL = "https://git.jackmechem.dev";
                SSH_DOMAIN = "gitssh.jackmechem.dev";
                SSH_PORT = 22;
            };
        };
    };

    # Make sure jack is in the shadow group
    users.users.jack.extraGroups = [ "shadow" ];

    environment.systemPackages = with pkgs; [
        neovim
        tree
        vim # Both vim and neovim just in case
        wget
        git
        gcc
        fastfetch
        brightnessctl
        killall
        unzip
        python3
        nodejs
        inputs.claude-code.packages.${pkgs.system}.claude-code
    ];

    virtualisation.docker.enable = true;

    services.libinput.enable = true;

    services.gvfs.enable = true;

    system.stateVersion = "25.11";

}
