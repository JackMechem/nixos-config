{ pkgs, ... }:

{
    services.jellyfin = {
        enable = true;
        openFirewall = false; # Caddy handles external access
        user = "jellyfin";
        group = "jellyfin";
    };

    # Allow jack to manage media directories owned by the jellyfin group
    users.users.jack.extraGroups = [ "jellyfin" ];
}
