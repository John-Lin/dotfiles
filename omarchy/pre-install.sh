#!/bin/bash
yay -S --noconfirm ghostty
yay -S --noconfirm fcitx5 fcitx5-gtk fcitx5-qt fcitx5-configtool fcitx5-chewing
yay -S pipewire pipewire-alsa pipewire-pulse alsa-utils alsa-ucm-conf
systemctl --user enable --now pipewire pipewire-pulse
pactl list short sinks
