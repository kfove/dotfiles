{ config, pkgs, helix, ... }:


{
  imports = [
    ./rice
    ./cnv
    ./apps
    ./fonts.nix
    ./rice/gtk.nix
  ];
  home.username = "dingduck";
  home.homeDirectory = "/home/dingduck";

  home.packages = with pkgs; [
    neofetch
    unzip
    dconf # GTK 需要， 不然报错
    nwg-look # 切换GTK主题
  ];

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
  programs.neovim = {
    enable = true;
  };

}
