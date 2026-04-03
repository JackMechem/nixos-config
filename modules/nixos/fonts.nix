{ pkgs, ... }:
{

    fonts = {
        packages = with pkgs; [
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-color-emoji
            liberation_ttf
            fira-code
            fira-code-symbols
            jetbrains-mono
            nerd-fonts.jetbrains-mono
            font-awesome
            google-fonts
            corefonts
            vista-fonts
            inter
            font-awesome_5
        ];

        fontconfig = {
            enable = true;
            defaultFonts = {
                serif = [ "Noto Serif" ];
                sansSerif = [ "Noto Sans" ];
                monospace = [ "JetBrains Mono" ];
                emoji = [ "Noto Color Emoji" ];
            };
        };
    };

}
