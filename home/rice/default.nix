{ ... }:

{
  imports = [
    ./hyprland
    ./waybar
    ./alacritty
    ./nixpkgs
    ./eww
    ./mako
  ];
  programs.neovim = {
    enable = true;
  };
}
