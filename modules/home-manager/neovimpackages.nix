{ pkgs, ... }:

{
    # Neovim itself is configured outside of Nix (~/.config/nvim is a plain
    # hand-managed dotfiles dir), so we intentionally avoid programs.neovim
    # here -- that module manages init.lua/init.vim and would conflict with
    # the existing config. We just install the editor plus the tooling it
    # expects on PATH.
    home.packages = with pkgs; [
        neovim

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
}
