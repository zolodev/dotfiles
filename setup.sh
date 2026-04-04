#!/usr/bin/env bash

echo "Installing dot files for current user"
echo $USER

# Getting the full path from where the script is executed from
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# Unlink previous links if any before remove files
unlink $HOME/.vimrc
unlink $HOME/.vim
unlink $HOME/.bashrc
unlink $HOME/.dir_colors
unlink $HOME/.tmux.conf
unlink $HOME/.start_tmux.sh
unlink $HOME/.hushlogin

# Remove any old files
if [ -f "$HOME/.bashrc" ]; then
    mv "$HOME/.bashrc" "$HOME/.bashrc.bak"
fi

rm -rf $HOME/.vimrc
rm -rf $HOME/.vim
rm -rf $HOME/.dir_colors
rm -rf $HOME/.tmux.conf
rm -rf $HOME/.start_tmux.sh
rm -rf $HOME/.hushlogin

# Setup new links
ln -s $SCRIPT_DIR/vimrc $HOME/.vimrc
ln -s $SCRIPT_DIR/vim $HOME/.vim
ln -s $SCRIPT_DIR/bashrc $HOME/.bashrc
ln -s $SCRIPT_DIR/.dir_colors $HOME/.dir_colors
ln -s $SCRIPT_DIR/tmux.conf $HOME/.tmux.conf
ln -s $SCRIPT_DIR/start_tmux.sh $HOME/.start_tmux.sh
ln -s $SCRIPT_DIR/hushlogin $HOME/.hushlogin


# This will install (if cron is available) and run auto update once each day
if [ -d "/etc/cron.daily" ]; then
    unlink /etc/cron.daily/auto_update.sh
    sudo ln -s $SCRIPT_DIR/auto_update.sh /etc/cron.daily/auto_update.sh
else
    echo "/etc/cron does not exist!"
fi


# Install tmux plugins
rm -rf "$HOME/.tmux/plugins/tpm"
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

# --- Install tmux.service only if tmux is installed ---
if command -v tmux >/dev/null 2>&1; then
    echo "tmux command found, trying to install tmux.service."

    # Skip systemd installation inside Toolbox
    if [ -f /run/.toolboxenv ]; then
        echo "Toolbox environment detected, will NOT install tmux.service."
    else
        # Installing systemd tmux.service
        SERVICE_NAME="tmux.service"
        USER_SERVICE_PATH="$HOME/.config/systemd/user/$SERVICE_NAME"

        # Remove old user service if it exists
        if systemctl --user list-unit-files | grep -q "^$SERVICE_NAME"; then
            systemctl --user disable --now tmux.service 2>/dev/null
        fi

        rm -rf "$USER_SERVICE_PATH"

        # Install new user service
        mkdir -p "$HOME/.config/systemd/user"
        ln -s "$SCRIPT_DIR/tmux.service" "$USER_SERVICE_PATH"

        # Remove old system service if it exists
        if systemctl list-unit-files | grep -q "^$SERVICE_NAME"; then
            systemctl disable --now tmux.service 2>/dev/null
        fi

        # Reload systemd and enable service
        systemctl --user daemon-reload
        systemctl --user enable --now tmux.service
    fi
else
    echo "Cannot find tmux, tmux.service will not be installed."
fi

# Print success message echo "Setup completed successfully" 
echo "Setup completed successfully"

# Ensure the script exits with status code 0 exit 0
exit 0
