#!/bin/bash

yes | sudo apt update && yes | sudo apt upgrade

echo "Last auto update ran:" > $HOME/.auto_update.log
date "+%Y-%m-%d %H:%M" >> $HOME/.auto_update.log
