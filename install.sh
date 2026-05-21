#!/usr/bin/env bash
set -e

# Paths can be changed
CONFIG_PATH="$HOME/.config"
BIN_PATH="$HOME/.local/bin/user-scripts"

DISPLAY_PATH="${CONFIG_PATH/$HOME/\$HOME}"

YELLOW=$'\033[1;33m'
RESET=$'\033[0m'
PREFIX="${YELLOW}[safer-installs]${RESET} "

run() {
    echo "    $*"
    "$@"
}

safe-copy() {
    SOURCE="$1"
    DESTINATION="$2"
    if [[ ! -f "$DESTINATION" ]]; then
        run cp "$SOURCE" "$DESTINATION"
        return
    fi

    # Configuration file already exist
    echo ""
    echo "${PREFIX}Configuration file \"$DESTINATION\" already exists. "
    echo -n "Move to \"$DESTINATION.backup\" and copy over new file [y/N]? "
    read -r answer
    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
        run mv "$DESTINATION" "${DESTINATION}.backup"
        run cp "$SOURCE" "$DESTINATION"
    else
        echo "Skipping configuration file. "
        echo ""
    fi
}

echo "${PREFIX}Setting up safer-installs by copying over files..."

run mkdir -p "$CONFIG_PATH/safer-installs"
run cp .zshrc-node .zshrc-python "$CONFIG_PATH/safer-installs"
run mkdir -p "$CONFIG_PATH/pnpm"
safe-copy "dotfiles/config.yaml" "$CONFIG_PATH/pnpm/config.yaml"
run mkdir -p "$CONFIG_PATH/uv"
safe-copy dotfiles/uv.toml "$CONFIG_PATH/uv/uv.toml"
run mkdir -p "$BIN_PATH"
run cp safer-npx "$BIN_PATH"
run chmod +x "$BIN_PATH/safer-npx"

echo "${PREFIX}Add the following lines to \"~/.zshrc\" to finish setting up:"
echo "source \"$DISPLAY_PATH/safer-installs/.zshrc-node\""
echo "source \"$DISPLAY_PATH/safer-installs/.zshrc-python\""
