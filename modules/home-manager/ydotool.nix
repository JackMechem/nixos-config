{ pkgs, ... }:

{
    home.packages = [ pkgs.ydotool ];

    # Daemon required for ydotool to function
    systemd.user.services.ydotoold = {
        Unit = {
            Description = "ydotool daemon";
            After = [ "default.target" ];
        };
        Service = {
            ExecStart = "${pkgs.ydotool}/bin/ydotoold";
            Restart = "always";
        };
        Install = {
            WantedBy = [ "default.target" ];
        };
    };
}
