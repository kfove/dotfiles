{ config, pkgs, ...}:


{
  home.username = "dingduck";
  home.homeDirectory = "/home/dingduck";

  home.packages = with pkgs; [
    neofetch
    firefox
    kitty
    alacritty
    ];

    home.stateVersion = "23.11";
    programs.home-manager.enable = true;
}
