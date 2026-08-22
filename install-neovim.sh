#!/usr/bin/env bash
set -euo pipefail

NVIM_BIN=/usr/local/bin/nvim
NVIM_CONFIG=~/.config/nvim
ZSHRC=~/.zshrc

info()    { echo "[+] $*"; }
skip()    { echo "[-] $* (already done, skipping)"; }
warn()    { echo "[!] $*"; }

# ── Step 1: Install Neovim ────────────────────────────────────────────────────

if [[ -x "$NVIM_BIN" ]]; then
    skip "Neovim already installed at $NVIM_BIN ($($NVIM_BIN --version | head -1))"
else
    info "Downloading Neovim AppImage (latest stable)..."
    TMP=$(mktemp)
    curl -L --progress-bar \
        https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage \
        -o "$TMP"
    chmod +x "$TMP"
    sudo mv "$TMP" "$NVIM_BIN"
    info "Neovim installed: $($NVIM_BIN --version | head -1)"
fi

# ── Step 2: Install fzf ───────────────────────────────────────────────────────
# apt's fzf is too old: fzf-lua's default multi-select keybinding needs
# $FZF_SELECT_COUNT, only available from fzf 0.46+. Install from GitHub instead.

FZF_BIN=/usr/local/bin/fzf
FZF_MIN_VERSION=0.46.0

if [[ -x "$FZF_BIN" ]] && printf '%s\n%s\n' "$FZF_MIN_VERSION" "$("$FZF_BIN" --version | awk '{print $1}')" | sort -V -C; then
    skip "fzf already installed at $FZF_BIN ($($FZF_BIN --version | head -1))"
else
    info "Downloading fzf (latest stable)..."
    FZF_VERSION=$(curl -s https://api.github.com/repos/junegunn/fzf/releases/latest | grep -oP '"tag_name": "v\K[^"]+')
    TMP_TGZ=$(mktemp --suffix=.tar.gz)
    TMP_DIR=$(mktemp -d)
    curl -L --progress-bar \
        "https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_amd64.tar.gz" \
        -o "$TMP_TGZ"
    tar -xzf "$TMP_TGZ" -C "$TMP_DIR"
    sudo mv "$TMP_DIR/fzf" "$FZF_BIN"
    sudo chmod +x "$FZF_BIN"
    rm -rf "$TMP_TGZ" "$TMP_DIR"
    info "fzf installed: $($FZF_BIN --version | head -1)"
fi

# ── Step 3: Install apt dependencies ─────────────────────────────────────────

MISSING_PKGS=()
dpkg -s ripgrep &>/dev/null || MISSING_PKGS+=(ripgrep)
dpkg -s fd-find &>/dev/null || MISSING_PKGS+=(fd-find)
dpkg -s nodejs  &>/dev/null || MISSING_PKGS+=(nodejs)
dpkg -s npm     &>/dev/null || MISSING_PKGS+=(npm)

if [[ ${#MISSING_PKGS[@]} -gt 0 ]]; then
    info "Installing apt packages: ${MISSING_PKGS[*]}"
    sudo apt-get install -y "${MISSING_PKGS[@]}"
else
    skip "apt packages already installed (ripgrep, fd-find, nodejs, npm)"
fi

# ── Step 4: Symlink fdfind → fd ───────────────────────────────────────────────

if [[ -x /usr/local/bin/fd ]]; then
    skip "fd symlink already exists"
else
    FDFIND=$(which fdfind 2>/dev/null || true)
    if [[ -z "$FDFIND" ]]; then
        warn "fdfind not found — fd symlink skipped"
    else
        sudo ln -s "$FDFIND" /usr/local/bin/fd
        info "Created symlink: /usr/local/bin/fd -> $FDFIND"
    fi
fi

# ── Step 5: Install LazyVim starter ──────────────────────────────────────────

if [[ -d "$NVIM_CONFIG" ]]; then
    skip "~/.config/nvim already exists — not touching existing config"
else
    info "Cloning LazyVim starter..."
    git clone https://github.com/LazyVim/starter "$NVIM_CONFIG"
    rm -rf "$NVIM_CONFIG/.git"
    info "LazyVim starter installed at $NVIM_CONFIG"
fi

# ── Step 6: Write lazyvim.json (language extras) ──────────────────────────────

LAZYVIM_JSON="$NVIM_CONFIG/lazyvim.json"

if [[ -f "$LAZYVIM_JSON" ]]; then
    skip "lazyvim.json already exists — not overwriting"
else
    cat > "$LAZYVIM_JSON" <<'EOF'
{
  "extras": [
    "lazyvim.plugins.extras.lang.elixir",
    "lazyvim.plugins.extras.lang.go",
    "lazyvim.plugins.extras.lang.erlang",
    "lazyvim.plugins.extras.lang.markdown"
  ]
}
EOF
    info "Written $LAZYVIM_JSON with lang extras (elixir, go, erlang, markdown)"
fi

# ── Step 7: Install JetBrainsMono Nerd Font ──────────────────────────────────

FONT_DIR=~/.local/share/fonts/JetBrainsMono

if [[ -d "$FONT_DIR" ]]; then
    skip "JetBrainsMono Nerd Font already installed"
else
    info "Downloading JetBrainsMono Nerd Font..."
    mkdir -p "$FONT_DIR"
    TMP_ZIP=$(mktemp --suffix=.zip)
    curl -L --progress-bar \
        https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip \
        -o "$TMP_ZIP"
    unzip -q "$TMP_ZIP" -d "$FONT_DIR"
    rm "$TMP_ZIP"
    fc-cache -f ~/.local/share/fonts
    info "JetBrainsMono Nerd Font installed"
    echo "    -> In xfce4-terminal: Edit > Preferences > Appearance"
    echo "       Uncheck 'Use system font', select 'JetBrainsMono Nerd Font Mono'"
fi

# ── Step 8: Add shell alias ───────────────────────────────────────────────────

ALIAS="alias nv='nvim'"

if grep -qF "$ALIAS" "$ZSHRC" 2>/dev/null; then
    skip "alias nv already present in $ZSHRC"
else
    echo "" >> "$ZSHRC"
    echo "# Neovim alias" >> "$ZSHRC"
    echo "$ALIAS" >> "$ZSHRC"
    info "Added 'alias nv=nvim' to $ZSHRC"
fi

# ── Done ──────────────────────────────────────────────────────────────────────

echo ""
echo "All done. Next steps:"
echo "  1. Set the font in xfce4-terminal:"
echo "     Edit > Preferences > Appearance > uncheck 'Use system font'"
echo "     Select: JetBrainsMono Nerd Font Mono, size 12"
echo "  2. Open a new terminal (or: source ~/.zshrc)"
echo "  3. Run: nvim"
echo "     LazyVim will bootstrap plugins on first launch (~1-2 min)"
echo "  4. Inside nvim, run: :LazyHealth  to verify everything is working"
