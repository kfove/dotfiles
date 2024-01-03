{ pkgs, lib, config, ... }:

{
  home.packages = with pkgs; [
    google-chrome
  ];
}
