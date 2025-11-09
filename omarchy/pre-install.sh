#!/bin/bash
# Install Fcitx5 and Chewing input method
yay -S --noconfirm fcitx5 fcitx5-gtk fcitx5-qt fcitx5-configtool fcitx5-chewing

# if pipewire is not installed 
# yay -S pipewire pipewire-alsa pipewire-pulse alsa-utils alsa-ucm-conf
# systemctl --user enable --now pipewire pipewire-pulse
# pactl list short sinks
