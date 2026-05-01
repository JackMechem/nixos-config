{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    yubikey-manager
    libfido2
  ];

  # Only FIDO2-backed SSH keys (ed25519-sk / ecdsa-sk) are accepted.
  # Every SSH login to every account requires a YubiKey touch.
  # Add your sk public key to ~/.ssh/authorized_keys before deploying:
  #   ssh-keygen -t ed25519-sk
  #   ssh-copy-id -i ~/.ssh/id_ed25519_sk.pub jack@dellserv
  services.openssh.settings.PubkeyAcceptedAlgorithms = "sk-ssh-ed25519@openssh.com,sk-ecdsa-sha2-nistp256@openssh.com";
}
