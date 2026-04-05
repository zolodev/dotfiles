#!/usr/bin/env bash

#****************************************************************************
# Filename      : tbxctl.sh
# Created       : Sat Apr 4 2026
# Author        : Zolo
# Github        : https://github.com/zolodev
# Description   : Control script to manage toolboxes in Fedora Silverblue.
#****************************************************************************

set -e

show_help() {
    echo "Usage:"
    echo "  $0 export <container-name>"
    echo "  $0 import <image-file>"
    echo
    echo "Example:"
    echo "  $0 export fedora-toolbox-43"
    echo "  $0 import fedora-toolbox-43-image.tar.gz"
}

if [[ $# -eq 0 ]]; then
    show_help
    exit 0
fi

# -----------------------------
# EXPORT
# -----------------------------
if [[ "$1" == "export" || "$1" == "-e" ]]; then
    if [[ -z "$2" ]]; then
        echo "Error: No container name provided."
        exit 1
    fi

    CONTAINER="$2"
    IMAGE_NAME="${CONTAINER}-image"
    OUTFILE="${IMAGE_NAME}.tar.gz"

    echo "Exporting toolbox '$CONTAINER'..."

    if ! podman container exists "$CONTAINER"; then
        echo "Error: Container '$CONTAINER' does not exist."
        exit 1
    fi

    echo "Committing container to image..."
    podman commit "$CONTAINER" "$IMAGE_NAME"

    echo "Saving image to $OUTFILE..."
    podman save "$IMAGE_NAME" | gzip > "$OUTFILE"

    echo "Export complete: $OUTFILE"
    exit 0
fi

# -----------------------------
# IMPORT
# -----------------------------
if [[ "$1" == "import" || "$1" == "-i" ]]; then
    if [[ -z "$2" ]]; then
        echo "Error: No image file provided."
        exit 1
    fi

    FILE="$2"

    if [[ ! -f "$FILE" ]]; then
        echo "Error: File '$FILE' not found."
        exit 1
    fi

    echo "Importing image from $FILE..."
    podman load -i "$FILE"

    # Extract image name from filename
    BASENAME=$(basename "$FILE")
    IMAGE_NAME="${BASENAME%.tar.gz}"
    DEFAULT_CONTAINER="${IMAGE_NAME%-image}"

    CONTAINER="$DEFAULT_CONTAINER"

    # Check if container already exists
    if podman container exists "$CONTAINER"; then
        echo
        echo "A toolbox named '$CONTAINER' already exists."
        echo "Choose an option:"
        echo "  1) Enter a new name"
        echo "  2) Auto-generate a new name"
        echo "  3) Overwrite existing toolbox"
        echo "  4) Cancel import"
        echo

        read -rp "Your choice (1/2/3/4): " CHOICE

        case "$CHOICE" in
            1)
                read -rp "Enter new container name: " NEWNAME
                if [[ -z "$NEWNAME" ]]; then
                    echo "Error: Name cannot be empty."
                    exit 1
                fi
                CONTAINER="$NEWNAME"
                ;;
            2)
                COUNT=1
                NEWNAME="${CONTAINER}-copy"
                while podman container exists "$NEWNAME"; do
                    COUNT=$((COUNT+1))
                    NEWNAME="${CONTAINER}-copy${COUNT}"
                done
                CONTAINER="$NEWNAME"
                echo "Auto-generated name: $CONTAINER"
                ;;
            3)
                echo "Overwriting existing toolbox '$CONTAINER'..."

                echo "Removing container..."
                podman rm -f "$CONTAINER" || true

                echo "Removing old images with same name..."
                podman rmi -f "$CONTAINER" || true
                podman rmi -f "${CONTAINER}-image" || true

                # DO NOT remove $IMAGE_NAME — that's the newly imported image
                ;;
            4)
                echo "Import cancelled."
                exit 0
                ;;
            *)
                echo "Invalid choice."
                exit 1
                ;;
        esac
    fi

    echo "Creating toolbox container '$CONTAINER'..."
    toolbox create --container "$CONTAINER" --image "$IMAGE_NAME"

    echo "Import complete. Toolbox '$CONTAINER' is ready."
    exit 0
fi

echo "Error: Unknown command '$1'"
show_help
exit 1