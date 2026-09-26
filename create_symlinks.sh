#!/bin/bash

# ANSI Color Codes (Reset after printing to prevent leaking styles to terminal)
COLOR_GREEN='\033[0;32m'
COLOR_RED='\033[0;31m'
COLOR_YELLOW='\033[0;33m'
COLOR_RESET='\033[0m'

# Formatting helpers for consistent alignment
TAG_OK="${COLOR_GREEN}[OK]${COLOR_RESET}"
TAG_LINKED="${COLOR_GREEN}[LINKED]${COLOR_RESET}"
TAG_REMOVED="${COLOR_RED}[REMOVED]${COLOR_RESET}"
TAG_SKIPPED="${COLOR_YELLOW}[SKIPPED]${COLOR_RESET}"
TAG_MISMATCH="${COLOR_RED}[MISMATCH]${COLOR_RESET}"
TAG_EXISTS="${COLOR_YELLOW}[EXISTS]${COLOR_RESET}"
TAG_MISSING="${COLOR_RED}[MISSING]${COLOR_RESET}"

# Resolve top-level directory dynamically relative to the script location
TOP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${HOME}/.config"

# Ensure target directory exists in user space 
mkdir -p "$TARGET_DIR"

# ==============================================================================
# Function: display_help
#   Input:   None
#   Output:  Prints formatted usage instructions and description to stdout.
#   Process: Outputs CLI syntax, available actions, and completion setup guide.
# ==============================================================================
display_help() {
    cat << EOF
Usage: $(basename "$0") <command>

A rootless utility to manage ~/.config symlinks for subdirectories in this repository.

Commands:
  check       Verify existing symlinks in ~/.config and report their current status.
  sync        Clean up existing symlinks and recreate/update them in ~/.config.
  help        Display this help message.

EOF
}

# ==============================================================================
# Function: check_links
#   Input:   Subdirectories in \$TOP_DIR
#   Output:  Prints link verification status ([OK], [MISMATCH], [EXISTS], [MISSING]) to stdout.
#   Process: Iterates over immediate subdirectories, reads matching target paths in
#            ~/.config, and checks if they are valid symlinks pointing to \$TOP_DIR.
# ==============================================================================
check_links() {
    echo "=== Checking Symlinks in $TARGET_DIR ==="
    for dir in "$TOP_DIR"/*/; do
        [ -d "$dir" ] || continue
        folder_name="$(basename "$dir")"
        link_path="$TARGET_DIR/$folder_name"

        if [ -L "$link_path" ]; then
            target="$(readlink "$link_path")"
            if [ "$target" = "${dir%/}" ]; then
                echo -e "$TAG_OK       $folder_name -> $target"
            else
                echo -e "$TAG_MISMATCH $folder_name -> $target (expected: ${dir%/})"
            fi
        elif [ -e "$link_path" ]; then
            echo -e "$TAG_EXISTS   $folder_name exists in ~/.config but is NOT a symlink"
        else
            echo -e "$TAG_MISSING  $folder_name is not linked"
        fi
    done
}

# ==============================================================================
# Function: sync_links
#   Input:   Subdirectories in \$TOP_DIR
#   Output:  Prints removal and recreation logs ([REMOVED], [SKIPPED], [LINKED]) to stdout.
#   Process: Performs a two-pass operation on each subdirectory in \$TOP_DIR:
#            1. Deletion phase: If a symlink exists at \$TARGET_DIR/\$folder_name, 
#               it is removed. Real files/directories are skipped for safety.
#            2. Update phase: Creates a fresh symbolic link using 'ln -sfn'.
# ==============================================================================
sync_links() {
    echo "=== Cleaning Old Symlinks in $TARGET_DIR ==="
    for dir in "$TOP_DIR"/*/; do
        [ -d "$dir" ] || continue
        folder_name="$(basename "$dir")"
        link_path="$TARGET_DIR/$folder_name"

        if [ -L "$link_path" ]; then
            rm "$link_path"
            echo -e "$TAG_REMOVED   $link_path"
        elif [ -e "$link_path" ]; then
            echo -e "$TAG_SKIPPED   $link_path is a real file/directory (manual removal required)"
        fi
    done

    echo ""
    echo "=== Creating / Updating Symlinks in $TARGET_DIR ==="
    for dir in "$TOP_DIR"/*/; do
        [ -d "$dir" ] || continue
        folder_name="$(basename "$dir")"
        source_path="${dir%/}"
        link_path="$TARGET_DIR/$folder_name"

        ln -sfn "$source_path" "$link_path"
        echo -e "$TAG_LINKED   $link_path -> $source_path"
    done
}

# Command dispatching
case "$1" in
    check)      check_links ;;
    sync)       sync_links ;;
    help|-h|--help) display_help ;;
    *)          
        echo "Error: Unknown or missing command '$1'" >&2
        echo "Run '$0 help' for usage instructions." >&2
        exit 1
        ;;
esac

