{ config, lib, pkgs, inputs, ... }:

let cfg = config.services.gtkapps;
in
{
  options.services.gtkapps = {
    enable = lib.mkEnableOption "Enable the gtkapps application";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      [ inputs.gtkapps.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  };
}

