# Neovim Configuration for Rust Development in Termux

This is a Neovim configuration tailored for Rust development on Android using Termux. It includes a suite of plugins for a modern and efficient development experience, managed by **`folke/lazy.nvim`**.

## Features

*   **Plugin Manager**: Uses **`folke/lazy.nvim`**.
*   **Language Support**: Robust Rust support via `rust-tools.nvim` (integrating `rust-analyzer`).
*   **Syntax Highlighting**: Provided by `nvim-treesitter` for various languages including Rust and Lua.
*   **Autocompletion**: `nvim-cmp` with sources for LSP, snippets (`LuaSnip`), buffer, and path.
*   **LSP Integration**: `neovim/nvim-lspconfig` for language server protocol support.
*   **Formatting**: `jose-elias-alvarez/null-ls.nvim` for formatters and linters, configured with:
    *   `stylua` for Lua.
    *   `shfmt` for shell scripts.
    *   `prettier` for Markdown, JSON, YAML, etc.
    *   `taplo` for TOML.
    *   Format on save is enabled.
*   **UI Enhancements**:
    *   `folke/tokyonight.nvim` colorscheme.
    *   `nvim-lualine/lualine.nvim` for a feature-rich statusline.
    *   `kyazdani42/nvim-tree.lua` for a file explorer.
    *   `nvim-telescope/telescope.nvim` for advanced fuzzy finding.
    *   `kyazdani42/nvim-web-devicons` for icons.
*   **Sensible Defaults**: Includes a range of options for improved editing experience (see `lua/options.lua`).
*   **Persistent Undo**: Undo history is saved across sessions.

## Prerequisites

### Important: Rust Setup on Termux (Recommended Workaround)

While Termux provides a powerful environment, users might encounter difficulties setting up a stable Rust development workflow directly, particularly with `rustup` for managing Rust toolchains.

**Recommended Workaround for Robust Rust Setup:**

If you face issues with `rustup` or general stability for Rust development directly within Termux, a more reliable approach is to:

1.  **Install Fedora Linux (CLI) on Termux via Andronix:**
    *   Andronix allows you to install various Linux distributions within Termux. Fedora is a good choice for development.
    *   Follow the instructions provided by Andronix to get Fedora CLI running.
2.  **Set up Rust and Neovim within Fedora:**
    *   Once inside the Fedora environment (e.g., by running `./start-fedora.sh` or similar), proceed with a fresh installation of:
        *   Rust (using the standard `rustup` method: `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`).
        *   Neovim (e.g., by downloading the AppImage, using a package manager like `dnf`, or building from source).
        *   All other necessary development tools and dependencies as listed in the "Prerequisites" section, but using Fedora's package manager (`dnf`).
3.  **Clone this Neovim Configuration:**
    *   Clone this Neovim configuration into `~/.config/nvim` *within the Fedora environment*.

This method provides a more standard and stable Linux environment for Rust development, bypassing potential Termux-specific compatibility issues with toolchains and build systems. All subsequent development work would then happen inside this Fedora chroot/proot environment.

---

1.  **Termux**: Install from F-Droid for the latest version.
2.  **Neovim**: Install the latest version in Termux:
    ```bash
    pkg update && pkg upgrade
    pkg install neovim git curl build-essential
    ```
    (`build-essential` is needed for compiling tree-sitter parsers and potentially other things).
3.  **Rust**: Install Rust via `rustup`:
    ```bash
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source $HOME/.cargo/env
    ```
    Ensure `rust-analyzer` is installed (rust-tools.nvim will try to manage it, but having it available is good):
    ```bash
    rustup component add rust-analyzer
    ```
4.  **Node.js and npm/yarn (Optional, for Prettier via null-ls)**:
    ```bash
    pkg install nodejs-lts
    # npm install -g prettier # Or install locally in projects
    ```
5.  **Required CLI Tools (for null-ls formatters/linters)**:
    ```bash
    pkg install stylua shfmt shellcheck taplo
    # For Python formatting/linting (if you uncomment in formatting.lua):
    # pip install black flake8
    ```
    Ensure these are in your `$PATH`.
6.  **Nerd Font**: For icons to display correctly, you **must** configure Termux to use a Nerd Font.
    *   Download a Nerd Font of your choice (e.g., from [Nerd Fonts website](https://www.nerdfonts.com/)).
    *   Place the font file (e.g., `MyNerdFont.ttf`) into `~/.termux/font.ttf` (create the directory if it doesn't exist).
    *   Run `termux-reload-settings` in your Termux session.

## Installation

1.  **Clone the repository**:
    ```bash
    git clone <repository_url> ~/.config/nvim
    ```
    (Replace `<repository_url>` with the actual URL of this repository).
    If you already have an nvim configuration, make sure to back it up first:
    `mv ~/.config/nvim ~/.config/nvim.bak`

2.  **Launch Neovim**:
    Open Neovim:
    ```bash
    nvim
    ```
    The first time you launch Neovim, **`lazy.nvim`** will automatically bootstrap itself (if not already present) and then process the plugin specifications found in `lua/plugins/`. It will download and set up all the configured plugins. You might see activity in the command line area as plugins are installed.

3.  **Manage Plugins (with `lazy.nvim`)**:
    *   **`lazy.nvim`** typically handles plugin installation and updates automatically on startup if changes are detected or new plugins are added.
    *   You can open the `lazy.nvim` interface by running `:Lazy` inside Neovim. This allows you to see the status of your plugins, sync them, check for updates, etc.
    *   Common commands:
        *   `:Lazy sync`: Synchronizes your configuration (installs missing, cleans unused).
        *   `:Lazy check`: Checks for updates.
        *   `:Lazy update`: Updates plugins.
        *   `:Lazy health`: Checks `lazy.nvim`'s status and your configuration.
    *   Restart Neovim after any significant plugin changes if prompted or if you encounter issues.

## Termux Specific Notes

*   **Clipboard**: The configuration sets `vim.opt.clipboard = "unnamedplus"`. This should integrate with the Termux clipboard if Neovim has clipboard support compiled. If you face issues, you might need to install `termux-api` (`pkg install termux-api`) and ensure clipboard permissions are granted to Termux.
*   **Performance**: While this configuration is not overly heavy, performance on older Android devices might vary.
*   **Tree-sitter Parsers**: Tree-sitter parsers are compiled locally. If you encounter issues, ensure `build-essential` (or `clang`/`gcc`) is installed in Termux. You can manage parsers via `:TSInstall <language>` or check their status with `:TSInstallInfo`.

## Basic Usage & Keybindings

*   **Leader Key**: The leader key is set to `<Space>`.
*   **Local Leader Key**: The local leader key is set to `\`.

Many keybindings are set up. Here are a few important ones:

*   **File Explorer (NvimTree)**:
    *   `<leader>e`: Toggle NvimTree.
*   **Telescope (Fuzzy Finder)**:
    *   `<leader>ff`: Find files.
    *   `<leader>fr`: Find recent files.
    *   `<leader>fg`: Live grep.
    *   `<leader>fb`: Find buffers.
    *   `<leader>fh`: Search help tags.
    *   `<leader>fR`: LSP References.
    *   `<leader>fD`: LSP Definitions.
    *   `<leader>fd`: Workspace Diagnostics.
*   **LSP Actions (contextual, in Rust files for example)**:
    *   `gd`: Go to Definition.
    *   `gD`: Go to Declaration.
    *   `K`: Hover documentation.
    *   `gr`: References.
    *   `<space>ca`: Code Actions.
    *   `<space>rn`: Rename.
*   **Window Management**:
    *   `<C-h/j/k/l>`: Navigate between splits.
    *   `<leader>sv`: Split vertically.
    *   `<leader>sh`: Split horizontally.
    *   `<leader>sx`: Close current split.
*   **Tab Management**:
    *   `<leader>to`: New tab.
    *   `<leader>tx`: Close tab.
    *   `<leader>tn/tp`: Next/Previous tab.

Explore `lua/options.lua` and the plugin configuration files (e.g., `lua/lsp.lua`, `lua/telescope.lua`) for more keybindings and settings.

## Troubleshooting

*   **Plugins not loading or errors on startup**:
    *   Run `:Lazy` to open the management UI and check for errors.
    *   Use `:Lazy sync` to try and reconcile your plugin state.
    *   Check `:Lazy health` for diagnostic information.
    *   Review Neovim's startup messages or logs (`nvim -V9 nvim.log`) for specific Lua errors.
*   **Icons not showing**: Ensure you have set up a Nerd Font correctly in Termux settings and reloaded Termux settings.
*   **`rust-analyzer` issues**: Check `:LspInfo` for status. `rust-tools.nvim` attempts to manage its installation. Ensure Rust itself is correctly installed.
*   **Formatter issues (stylua, etc.)**: Make sure the respective CLI tools are installed in Termux and accessible in your `$PATH`. Check `:NullLsInfo`.

## Contributing

Feel free to fork this repository, make improvements, and suggest changes via pull requests.
