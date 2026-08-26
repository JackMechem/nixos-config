{ lib, pkgs, ... }:

let
    # filebrowser/filebrowser was archived upstream (final release 2.63.23);
    # gtsteffaniak/filebrowser ("FileBrowser Quantum") is the actively
    # maintained fork. nixpkgs ships the package but not a NixOS module yet,
    # so the systemd unit is hand-rolled below.
    package = pkgs.filebrowser-quantum;

    stateDir = "/var/lib/filebrowser";
    adminEnvFile = "${stateDir}/admin.env";

    configFormat = pkgs.formats.yaml { };
    configFile = configFormat.generate "filebrowser-quantum-config.yaml" {
        server = {
            port = 8095;
            listen = "127.0.0.1";
            database = "${stateDir}/filebrowser.sqlite";
            sources = [
                {
                    path = "/movies";
                    name = "Movies";
                    config.defaultEnabled = true;
                }
                {
                    path = "/music";
                    name = "Music";
                    config.defaultEnabled = true;
                }
            ];
        };
        auth = {
            adminUsername = "admin";
            methods.password.enabled = true;
        };
    };

    # The admin password isn't in configFile (that'd land world-readable in
    # the Nix store / git). Generated once into stateDir on first start and
    # logged, same as filebrowser/filebrowser's old first-run behavior.
    generateAdminPassword = pkgs.writeShellScript "filebrowser-quantum-generate-admin-password" ''
        set -eu
        # No pipefail: `tr` reading /dev/urandom gets SIGPIPE once `head`
        # has enough bytes and exits, which pipefail would treat as failure.
        if [ ! -f "${adminEnvFile}" ]; then
            password=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 20)
            printf 'FILEBROWSER_ADMIN_PASSWORD=%s\n' "$password" > "${adminEnvFile}"
            chmod 600 "${adminEnvFile}"
            echo "User 'admin' initialized with randomly generated password: $password"
        fi
    '';
in
{
    # setgid on the real directories so anything uploaded lands in the
    # jellyfin group, letting the jellyfin service read it back out.
    systemd.tmpfiles.settings.mediaDirs = {
        "/movies".d = {
            user = "root";
            group = "jellyfin";
            mode = "2775";
        };
        "/music".d = {
            user = "root";
            group = "jellyfin";
            mode = "2775";
        };
    };

    users.users.filebrowser = {
        isSystemUser = true;
        group = "filebrowser";
        extraGroups = [ "jellyfin" ];
    };
    users.groups.filebrowser = { };

    systemd.services.filebrowser = {
        description = "FileBrowser Quantum";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
            ExecStartPre = generateAdminPassword;
            ExecStart = "${lib.getExe package} -c ${configFile}";
            # "-" prefix: optional, since ExecStartPre (which creates this
            # file) is itself subject to EnvironmentFile= and would fail to
            # spawn on first boot if it were required to exist already.
            EnvironmentFile = "-${adminEnvFile}";

            StateDirectory = "filebrowser";
            WorkingDirectory = stateDir;

            User = "filebrowser";
            Group = "filebrowser";
            # Module default (0077) would make uploads unreadable by the
            # jellyfin group even with the setgid bit above; loosen it so
            # group-read works.
            UMask = "0027";

            NoNewPrivileges = true;
            PrivateDevices = true;
            ProtectKernelTunables = true;
            ProtectKernelModules = true;
            ProtectControlGroups = true;
            RestrictSUIDSGID = true;
        };
    };
}
