{ pkgs, lib, config, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # 打开 SteamPlay 的端口(firewall)
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
}
