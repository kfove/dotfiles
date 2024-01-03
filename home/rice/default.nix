{ ... }:

{
  imports = [
    ./hyprland
    ./waybar
    ./alacritty
    ./nixpkgs
    ./dunst.nix
    ./eww
  ];
  programs.neovim = {
    enable = true;
  };
}
