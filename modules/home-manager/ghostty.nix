{ pkgs, ... }:

{
    programs.ghostty = {
        enable = true;
        package = pkgs.ghostty;

        settings = {
            # --- Look ---
            "font-family" = "JetBrainsMono Nerd Font";
            "font-size" = 14;

            "window-padding-x" = 8;
            "window-padding-y" = 8;

            # --- Kanagawa theme ---
            palette = [
                "0=#181616"
                "1=#c4746e"
                "2=#8a9a7b"
                "3=#c4b28a"
                "4=#8ba4b0"
                "5=#a292a3"
                "6=#8ea4a2"
                "7=#bcb093"
                "8=#a6a69c"
                "9=#e46876"
                "10=#87a987"
                "11=#6c8384"
                "12=#7fb4ca"
                "13=#938aa9"
                "14=#7aa89f"
                "15=#c5c9c5"
            ];

            background = "#181616";
            foreground = "#c5c9c5";
            "cursor-color" = "#c8c093";
            "selection-background" = "#2d4f67";
            "selection-foreground" = "#c8c093";
        };
    };
}
