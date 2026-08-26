{ pkgs, ... }:

{
    programs.neovim = {
        enable = true;
        extraPackages = with pkgs; [

            # ===== Lua =====
            lua-language-server
            stylua

            # ===== JavaScript / TypeScript / React =====
            nodejs_22
            typescript
            typescript-language-server
            vscode-langservers-extracted
            bash-language-server
            prettier
            eslint_d
            eslint

            # ===== Nix =====
            nil
            nixd
            alejandra
            nixfmt

            # ===== C / C++ =====
            clang-tools

            # ===== Java =====
            jdt-language-server
            jdk21

            # ===== Rust =====
            rust-analyzer
            rustc
            cargo
            rustfmt
            clippy

            # ===== TOML =====
            taplo
        ];
    };
}
