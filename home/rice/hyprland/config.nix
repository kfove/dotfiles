{ config, lib, ... }:

{
  wayland.windowManager.hyprland = {
    settings = {
      "$MOD" = "SUPER";
      bind = [
        "$MOD, RETURN, exec, alacritty"
	"$MOD, SPACE, exec, wofi --show drun"
	"$MOD, Q, killactive"
      ];
    };
}
