{ pkgs, lib, config, ... }:

{
  xdg.configFile."alacritty/alacritty.yml".source = ./alacritty.yml;
}
