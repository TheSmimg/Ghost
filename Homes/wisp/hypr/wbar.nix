{ lib, pkgs, self, host, user, inputs, config, ... }: let
  profile = ((import ../../../Hosts/${host}.nix) { inherit lib self user; }).profile;
  theme = profile.theme;
in {
  programs.waybar = {
    enable = true;
    settings                  = [{
      position                = "top";
      modules-left            = [
        "custom/padd"
        "custom/l_end"
        "hyprland/workspaces"
        "custom/r_end"
        "custom/l_end"
        "wlr/taskbar"
        "custom/r_end"
        "custom/padd"
      ];

      modules-right           = [
        "custom/padd"
        "custom/l_end"
        "tray"
        "network"
        "pulseaudio"
        "clock"
        "custom/r_end"
        "custom/padd"
      ];

      "custom/padd"           = {
        format                = "   ";
        interval              = "once";
        tooltip               = false;
      };

      "custom/l_end"          = {
        format                = " ";
        interval              = "once";
        tooltip               = false;
      };

      "custom/r_end"          = {
        format                = " ";
        interval              = "once";
        tooltip               = false;
      };

      "hyprland/workspaces"   = {
        disable-scroll        = true;
        rotation              = 0;
        all-outputs           = true;
        active-only           = false;
        on-click              = "activate";
        format                = "{icon}";
        "format-icons"        = {
          "default"           = "󰧞";
        };
        "persistent-workspaces" = { "*" = 4; };
      };

      "wlr/taskbar"           = {
        format                = "{icon}";
        rotate                = 0;
        icon-size             = 16;
        icon-theme            = "tela-circle-dark";
        spacing               = 0;
        tooltip-active        = "{title}";
        on-click              = "activate";
        on-click-middle       = "close";
      };

      "clock"                 = {
        format                = "   {:%A · %R}";
        rotate                = 0;
        format-alt            = "{󰃭 %d · %m · %y}";
        tooltip-format        = "<span>{calendar}</span>";
        
        "calendar"            = {
          mode                = "month";
          mode-mon-col        = 3;
          on-scroll           = 1;
          on-click-right      = "mode";
          "format"            = {
            months            = "<span color='#${theme.pallette.base0A}'><b>{}</b></span>";
            weekdays          = "<span color='#${theme.pallette.base09}'><b>{}</b></span>";
            today             = "<span color='#${theme.pallette.base08}'><b>{}</b></span>";
          };
        };

        "actions"             = {
          on-click-right      = "mode";
          on-click-forward    = "tz_up";
          on-click-backwards  = "tz_down";
          on-scroll-up        = "shift_up";
          on-scroll-down      = "shift_down";
        };
      };

      "tray"                  = {
        icon-size             = 16;
        rotate                = 0;
        spacing               = 5;
      };

      "custom/music"          = {
        format                = " {}";
        rotate                = 0;
        exec                  = "${pkgs.playerctl}/bin/playerctl";
        on-click              = "${pkgs.playerctl}/bin/playerctl play-pause";
        on-click-right        = "${pkgs.playerctl}/bin/playerctl next";
        on-click-middle       = "${pkgs.playerctl}/bin/playerctl previous";
        max-length            = 25;
        escape                = true;
        tooltip               = true;
      };

      "network"               = {
        tooltip               = true;
        format-wifi           = "   {essid}";
        format-ethernet       = " 󰈀  {ipaddr}";
        format-linked         = " 󰈀  {ipaddr} (No IP)";
        format-disconnected   = " 󰖪 ";
        rotate                = 0;
        tooltip-format        = "Network <big><b>{essid}</b></big>\nSignal strength: <b>{signaldBm} ({signalStrength}%)</b>\nFrequency: <b>{frequency}MHz</b>\nInterface: <b>{ifname}</b>\nIP: <b>{ipaddr}/{cidr}</b>\nGateway: <b>{gwaddr}</b>\nNetmask: <b>{netmask}</b>";
        tooltip-format-disconnected = "Disconnected";
        format-alt            = "<span forground='${theme.pallette.base0C}'> {bandwidthDownBytes}</span> <span forground='${theme.pallette.base09}'> {bandwidthUpBytes}</span>";
        interval              = 2;
      };

      "pulseaudio"            = {
        format                = " {icon} {volume}";
        rotate                = 0;
        format-muted          = " 󰝟 ";
        on-click              = "${pkgs.pavucontrol}/bin/pavucontrol -t 3";
        tooltip-format        = "{icon} {desc} // {volume}%";
        scroll-step           = 5;
        format-icons          = {
          headphones          = "";
          hands-free          = "";
          headset             = "";
          phone               = "";
          portable            = "";
          car                 = "";
          default             = [ "" " " " " ];
        };
      };

      "pulseaudio#microphone" = {
        format                = "{format_source}";
        rotate                = 0;
        format-source         = "";
        format-source-muted   = "";
        on-click              = "${pkgs.pavucontrol}/bin/pavucontrol -t 4";
      };
    }];

  style = lib.concatStrings [''
    * {
      border: none;
      border-radius: 0px;
      font-family: "JetBrainsMono Nerd Font";
      font-weight: bold;
      font-size: 16px;
      min-height: 16px;
    }

    @define-color bar-bg rgba(0, 0, 0, 0);

    @define-color main-bg #${theme.pallette.base01};
    @define-color main-fg #${theme.pallette.base05};

    @define-color wb-act-bg #${theme.pallette.base07};
    @define-color wb-act-fg #${theme.pallette.base02};

    @define-color wb-hvr-bg #${theme.pallette.base06};
    @define-color wb-hvr-fg #${theme.pallette.base02};

    window#waybar {
      background: @bar-bg;
    }

    tooltip {
      background: @main-bg;
      color: @main-fg;
      border-radius: 7px;
      border-width: 0px;
    }

    #workspaces button {
      box-shadow: none;
      text-shadow: none;
      padding: 0px;
      border-radius: 9px;
      margin-top: 3px;
      margin-bottom: 3px;
      margin-left: 0px;
      padding-left: 3px;
      padding-right: 3px;
      margin-right: 0px;
      color: @main-fg;
      animation: ws_normal 20s ease-in-out 1;
    }

    #workspaces button.active {
      background: @wb-act-bg;
      color: @wb-act-fg;
      margin-left: 3px;
      padding-left: 12px;
      padding-right: 12px;
      margin-right: 3px;
      animation: ws_active 20s ease-in-out 1;
      transition: all 0.4s cubic-bezier(.55,-0.68,.48,1.682);
    }

    #workspaces button:hover {
      background: @wb-hvr-bg;
      color: @wb-hvr-fg;
      animation: ws_hover 20s ease-in-out 1;
      transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
    }

    #taskbar button {
      box-shadow: none;
      text-shadow: none;
      padding: 0px;
      border-radius: 9px;
      margin-top: 3px;
      margin-bottom: 3px;
      margin-left: 0px;
      padding-left: 3px;
      padding-right: 3px;
      margin-right: 0px;
      color: @wb-color;
      animation: tb_normal 20s ease-in-out 1;
    }

    #taskbar button.active {
      background: @wb-act-bg;
      color: @wb-act-color;
      margin-left: 3px;
      padding-left: 12px;
      padding-right: 12px;
      margin-right: 3px;
      animation: tb_active 20s ease-in-out 1;
      transition: all 0.4s cubic-bezier(.55,-0.68,.48,1.682);
    }

    #taskbar button:hover {
      background: @wb-hvr-bg;
      color: @wb-hvr-color;
      animation: tb_hover 20s ease-in-out 1;
      transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
    }

    #tray menu * {
      min-height: 16px
    }

    #tray menu separator {
      min-height: 10px
    }

    #backlight,
    #battery,
    #bluetooth,
    #custom-cliphist,
    #clock,
    #custom-cpuinfo,
    #cpu,
    #custom-gpuinfo,
    #idle_inhibitor,
    #custom-keybindhint,
    #language,
    #memory,
    #mpris,
    #network,
    #custom-notifications,
    #custom-power,
    #pulseaudio,
    #custom-music,
    #taskbar,
    #custom-theme,
    #tray,
    #custom-updates,
    #custom-wallchange,
    #custom-wbar,
    #window,
    #workspaces,
    #custom-l_end,
    #custom-r_end,
    #custom-sl_end,
    #custom-sr_end,
    #custom-rl_end,
    #custom-rr_end {
      color: @main-fg;
      background: @main-bg;
      opacity: 1;
      margin: 4px 0px 4px 0px;
      padding-left: 4px;
      padding-right: 4px;
    }

    #workspaces,
    #taskbar {
      padding: 0px;
    }

    #custom-r_end {
      border-radius: 0px 21px 21px 0px;
      margin-right: 9px;
      padding-right: 3px;
    }

    #custom-l_end {
      border-radius: 21px 0px 0px 21px;
      margin-left: 9px;
      padding-left: 3px;
    }

    #custom-sr_end {
      border-radius: 0px;
      margin-right: 9px;
      padding-right: 3px;
    }

    #custom-sl_end {
      border-radius: 0px;
      margin-left: 9px;
      padding-left: 3px;
    }

    #custom-rr_end {
      border-radius: 0px 7px 7px 0px;
      margin-right: 9px;
      padding-right: 3px;
    }

    #custom-rl_end {
      border-radius: 7px 0px 0px 7px;
      margin-left: 9px;
      padding-left: 3px;
    }
  ''];
  };
}

