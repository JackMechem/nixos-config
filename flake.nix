{
    description = "Nixos config flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        gtkapps.url = "github:JackMechem/gtkapps";
        gtkbar.url = "github:JackMechem/gtkbar";
        #    midirun.url = "path:/home/jack/Projects/midirun";

        zen-browser = {
            url = "github:0xc000022070/zen-browser-flake";
            # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
            # to have it up-to-date or simply don't specify the nixpkgs input
            inputs.nixpkgs.follows = "nixpkgs";
        };
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        rust-app-menu.url = "github:JackMechem/rust-app-menu";
        rust-app-menu.inputs.nixpkgs.follows = "nixpkgs";
        claude-code.url = "github:sadjow/claude-code-nix";
    };

    outputs =
        { self, nixpkgs, ... }@inputs:
        {
            # use "nixos", or your hostname as the name of the configuration
            # it's a better practice than "default" shown in the video
            nixosConfigurations.t480 = nixpkgs.lib.nixosSystem {
                specialArgs = { inherit inputs; };
                modules = [
                    ./hosts/t480/configuration.nix
                    inputs.home-manager.nixosModules.default
                ];
            };
            nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
                specialArgs = { inherit inputs; };
                modules = [
                    ./hosts/desktop/configuration.nix
                    inputs.home-manager.nixosModules.default
                    #inputs.midirun.nixosModules.default
                ];
            };
            nixosConfigurations.dellserv = nixpkgs.lib.nixosSystem {
                specialArgs = { inherit inputs; };
                modules = [
                    ./hosts/dellserv/configuration.nix
                    inputs.home-manager.nixosModules.default
                    (builtins.getFlake "path:/home/jack/Projects/server-dash").nixosModules.default
                    (builtins.getFlake "path:/home/jack/Projects/server-dash-api").nixosModules.default
                ];
            };
        };
}
