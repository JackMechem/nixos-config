{ config, lib, pkgs, inputs, ... }:

let cfg = config.services.gtkbar;
in
{
  options.services.gtkbar = {
    enable = lib.mkEnableOption "Enable the gtkbar application";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      [ inputs.gtkbar.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  };
}

