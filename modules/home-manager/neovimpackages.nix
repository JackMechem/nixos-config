{pkgs, ... }:

{
    programs.neovim = {
        enable = true;
        extraPackages = with pkgs; [
            # lua
            lua-language-server
            stylua
            # javascript/typescript/react
            nodejs_20
            typescript
            nodePackages.typescript-language-server
            nodePackages.vscode-langservers-extracted
            nodePackages.bash-language-server
            nodePackages.prettier
            nodePackages.eslint_d
            nodePackages.eslint
            # nix
            nil
            nixd
            alejandra
            nixfmt
            # clang
            clang-tools
        ];
    };
}
