{ pkgs, inputs, ... }:

{
  imports = [
    ./config.nix
  ];
  home.packages = with pkgs; [
    neofetch
    firefox
    kitty
    wofi
    alacritty
    wqy_zenhei
    nerdfonts
    xfce.thunar
    wofi
    swaybg
    wlsunset
    wl-clipboard
    waybar
    wlogout
    slurp
    grim
    swappy
    btop
  ];
  wayland.windowManager.hyprland.enable = true;
}

