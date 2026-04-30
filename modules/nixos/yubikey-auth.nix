{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    yubikey-manager
    libfido2
  ];

  # sudo authenticates via the forwarded SSH agent.
  # Requires: ssh -A when connecting, and an ed25519-sk key in your agent.
  # Generate one locally if you haven't:
  #   ssh-keygen -t ed25519-sk
  # Then add the public key to ~/.ssh/authorized_keys on the server.
  security.pam.sshAgentAuth.enable = true;
  security.pam.services.sudo.sshAgentAuth = true;

  # Preserve the forwarded agent socket across the sudo boundary
  security.sudo.extraConfig = ''
    Defaults env_keep+=SSH_AUTH_SOCK
  '';
}
