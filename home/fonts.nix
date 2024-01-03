{ pkgs, config, lib, ... }:

{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    jetbrains-mono
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
  ];
}
