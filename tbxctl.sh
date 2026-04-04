#!/usr/bin/env bash

show_help() {
    echo "Usage:"
    echo "  $0 export <container-name>"
    echo "  $0 -e <container-name>"
    echo "      Export a toolbox container to <container-name>.tar.gz"
    echo
    echo "  $0 import <path-to-tar.gz>"
    echo "  $0 -i <path-to-tar.gz>"
    echo "      Import a toolbox container from a tar.gz file"
    echo
    echo "Example:"
    echo "  $0 export fedora-toolbox-43"
    echo "  $0 import fedora-toolbox-43.tar.gz"
}

# --- No parameters → show help ---
if [[ $# -eq 0 ]]; then
    show_help
    exit 0
fi

# --- Export ---
if [[ "$1" == "export" || "$1" == "-e" ]]; then
    if [[ -z "$2" ]]; then
        echo "Error: No container name provided."
        show_help
        exit 1
    fi

    CONTAINER="$2"
    OUTFILE="${CONTAINER}.tar.gz"

    echo "Exporting container '$CONTAINER' to '$OUTFILE'..."

    # Check if container exists
    if ! podman container exists "$CONTAINER"; then
        echo "Error: Container '$CONTAINER' does not exist."
        exit 1
    fi

    # Export and compress
    podman container export "$CONTAINER" | gzip > "$OUTFILE"

    echo "Export complete: $OUTFILE"
    exit 0
fi

# --- Import ---
if [[ "$1" == "import" || "$1" == "-i" ]]; then
    if [[ -z "$2" ]]; then
        echo "Error: No file provided."
        show_help
        exit 1
    fi

    FILE="$2"

    if [[ ! -f "$FILE" ]]; then
        echo "Error: File '$FILE' not found."
        exit 1
    fi

    # Extract container name from filename
    BASENAME=$(basename "$FILE")
    CONTAINER="${BASENAME%.tar.gz}"

    echo "Importing container from '$FILE' as '$CONTAINER'..."

    # Import image
    podman import "$FILE" "$CONTAINER"

    echo "Container imported as image '$CONTAINER'."
    echo "Creating toolbox container..."

    toolbox create --container "$CONTAINER"

    echo "Import complete. Toolbox container '$CONTAINER' is ready."
    exit 0
fi

# --- Unknown parameter ---
echo "Error: Unknown command '$1'"
show_help
exit 1

