{ config, pkgs, lib, ... }:

{
  services.mako = {
    enable = true;
    defaultTimeout = 4000;
  };
  xdg.configFile."mako/config".source = ./config;
}
