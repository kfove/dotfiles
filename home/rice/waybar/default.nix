{ pkgs
, lib
, config
, ...
}:
let
  mullvad-status =
    pkgs.writeShellScriptBin "mullvad-status"
      ''
        #!/bin/sh
        mullvad status | awk '{print $1;}'
      '';
in
{
  xdg.configFile."waybar/style.css".text = import ./style.nix;
  xdg.configFile."waybar/clock.sh".source = ./clock.sh;
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 38;
        spacing = 6;
        fixed-center = false;
        margin-left = null;
        margin-top = null;
        margin-bottom = null;
        margin-right = null;
        exclusive = true;
        modules-left = [
          "custom/search"
          "hyprland/workspaces"
          "backlight"
          "cpu"
          "memory"
          "battery"
        ];
        modules-center = [ ];
        modules-right = [ "custom/weather" "pulseaudio" "network" "tray" "custom/clock" ];
        "hyprland/workspaces" = {
          on-click = "activate";
          format = "{icon}";
          active-only = false;
          format-icons = {
            "1" = "󰪃";
            "2" = "󰩾";
            "3" = "󰪁";
            "4" = "󰪂";
            "5" = "󰪇";
            "6" = "󰪆";
            "7" = "󰩽";
            "8" = "󰩿";
            "9" = "󰪄";
            "10" = "󰪈";
          };

          persistent_workspaces = {
            "*" = 5;
          };
        };
        "custom/search" = {
          format = " ";
          tooltip = false;
          on-click = "sh -c 'run-as-service $(tofi-drun)'";
        };

        "custom/weather" =
          let
            weather = pkgs.stdenv.mkDerivation {
              name = "waybar-wttr";
              buildInputs = [
                (pkgs.python39.withPackages
                  (pythonPackages: with pythonPackages; [ requests pyquery ]))
              ];
              unpackPhase = "true";
              installPhase = ''
                mkdir -p $out/bin
                cp ${./weather.py} $out/bin/weather
                chmod +x $out/bin/weather
              '';
            };
          in
          {
            format = "{}";
            tooltip = true;
            interval = 30;
            exec = "${weather}/bin/weather";
            return-type = "json";
          };
        "custom/crypto" =
          let
            crypto = pkgs.stdenv.mkDerivation {
              name = "waybar-wttr";
              buildInputs = [
                (pkgs.python39.withPackages
                  (pythonPackages: with pythonPackages; [ requests ]))
              ];
              unpackPhase = "true";
              installPhase = ''
                mkdir -p $out/bin
                cp ${./crypto.py} $out/bin/crypto
                chmod +x $out/bin/crypto
              '';
            };
          in
          {
            format = "{}";
            tooltip = true;
            interval = 30;
            exec = "${crypto}/bin/crypto";
            return-type = "json";
          };
        "custom/vpn" = {
          format = " VPN {}";
          tooltip = true;
          interval = 1;
          exec = "${lib.getBin mullvad-status}/mullvad-status";
        };
        "custom/lock" = {
          tooltip = false;
          on-click = "sh -c '(sleep 0.5s; ${pkgs.gtklock}/bin/gtklock)' & disown";
          format = "";
        };
        "custom/swallow" = {
          tooltip = false;
          on-click =
            let
              hyprctl = config.wayland.windowManager.hyprland.package + "/bin/hyprctl";
              notify-send = pkgs.libnotify + "/bin/notify-send";
              rg = pkgs.ripgrep + "/bin/rg";
            in
            pkgs.writeShellScript "waybar-swallow" ''
              #!/bin/sh
              if ${hyprctl} getoption misc:enable_swallow | ${rg}/bin/rg -q "int: 1"; then
              	${hyprctl} keyword misc:enable_swallow false >/dev/null &&
              		${notify-send} "Hyprland" "Turned off swallowing"
              else
              	${hyprctl} keyword misc:enable_swallow true >/dev/null &&
              		${notify-send} "Hyprland" "Turned on swallowing"
              fi
            '';
          format = "󰘻";
        };
        "custom/power" = {
          tooltip = false;
          # TODO
          format = "󰐥";
        };
        clock = {
          format-alt = "{:%Y-%m-%d}";
          tooltip-format = "{:%Y-%m-%d | %H:%M}";
        };
        backlight = {
          format = "{icon}  {percent}%";
          format-icons = [ "" "" "" "" "" "" "" "" "" ];
        };
        memory = {
          interval = 2;
          format = "  {}%";
          max-length = 10;
        };
        cpu = {
          interval = 2;
          format = "󰍛 {}%";
          max-length = 10;
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}% 󱐋{power}";
          format-charging = "󰚥{icon} {capacity}% 󱐋{power}";
          format-alt = "{icon} {capacity}%";
          format-icons = [ "󰂃" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        };
        network =
          let
            nm-editor = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
          in
          {
            format-wifi = "󰤨  {signalStrength}%";
            format-ethernet = "󰈀";
            format-alt = "󱛇";
            format-disconnected = "󰤭";
            tooltip-format = "{ipaddr}/{ifname} via {gwaddr} ({signalStrength}%)";
            on-click-right = "${nm-editor}";
          };
        pulseaudio = {
          scroll-step = 5;
          tooltip = true;
          tooltip-format = "{volume}%";
          on-click-right = "${pkgs.killall}/bin/killall pavucontrol || ${pkgs.pavucontrol}/bin/pavucontrol";
          format = "{icon} {volume}%";
          format-muted = "󰝟 ";
          format-icons = {
            default = [ "" "" " " ];
          };
        };
        tray = {
          icon-size = 21;
          spacing = 10;
        };
        "custom/clock" = {
          "return-type" = "json";
          "exec" = "./clock.sh";
          "format" = "{}";
          "interval" = 2;
          "tooltip" = true;
          "format-icons" = [ "" ];
        };
      };
    };
  };
}
