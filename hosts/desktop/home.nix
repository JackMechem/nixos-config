{
    config,
    pkgs,
    inputs,
    ...
}:

{
    imports = [
        inputs.zen-browser.homeModules.twilight

        # --- Shell ---
        ../../modules/home-manager/zsh.nix
        ../../modules/home-manager/shell-aliases.nix
        ../../modules/home-manager/tmux.nix

        # --- Desktop ---
        ../../modules/home-manager/hyprland-desktop.nix
        ../../modules/home-manager/theme.nix         # GTK icons + cursor
        ../../modules/home-manager/ghostty.nix        # terminal emulator

        # --- Tools ---
        ../../modules/home-manager/ydotool.nix        # input automation daemon
        ../../modules/home-manager/neovimpackages.nix

        # --- Packages ---
        # Add home-manager packages in homepackages.nix
        ../../modules/home-manager/homepackages.nix
    ];

    programs.home-manager.enable = true;

    home.username = "jack";
    home.homeDirectory = "/home/jack";
    home.stateVersion = "25.05";

    home.file = { };
    xdg.configFile = { };

    programs.zen-browser.enable = true;

    nixpkgs.config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
    };

    home.sessionVariables = {
        EDITOR = "nvim";
        # Route claw-code to local Ollama instead of Anthropic/OpenAI
        OPENAI_BASE_URL = "http://127.0.0.1:11434/v1";
        OPENAI_API_KEY = "ollama";
    };
}
