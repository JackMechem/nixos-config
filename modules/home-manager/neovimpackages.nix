{ pkgs, ... }:

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
            typescript-language-server
            vscode-langservers-extracted
            bash-language-server
            prettier
            eslint_d
            eslint
            # nix
            nil
            nixd
            alejandra
            nixfmt
            # clang
            clang-tools
            # java
            jdt-language-server
            jdk21
            # rust
            rust-analyzer
            rustc
            cargo
            rustfmt
            taplo # LSP for TOML
            clippy
        ];
    };
}
