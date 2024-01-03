{ pkgs, lib, config, nur, ... }:

{
  imports = [
    ./google_chrome
    ./steam
  ];
  home.packages = with pkgs; [
    qq
    yazi # 一款cli file manager
    jq
  ];
}
