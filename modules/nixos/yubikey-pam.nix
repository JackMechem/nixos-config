{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    yubikey-manager
    libfido2
  ];

  # pam_u2f: requires physical YubiKey touch for sudo and TTY login.
  # Enroll your key BEFORE rebuilding (run on this machine):
  #   nix shell nixpkgs#pam_u2f -c pamu2fcfg -u jack | sudo tee /etc/u2f-mappings
  # Touch the key when the LED blinks.
  # Additional keys: nix shell nixpkgs#pam_u2f -c pamu2fcfg -n -u jack | sudo tee -a /etc/u2f-mappings
  security.pam.u2f = {
    enable = true;
    control = "required";
    settings = {
      cue = true;
      authfile = "/etc/u2f-mappings";
    };
  };

  security.pam.services.sudo.u2fAuth = true;
  security.pam.services.login.u2fAuth = true;
  security.pam.services.hyprlock.u2fAuth = true;
}
