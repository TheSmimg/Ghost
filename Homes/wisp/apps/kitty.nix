{ lib, pkgs, self, host, user, inputs, config, ... }: let
  profile = ((import ../../../Hosts/${host}.nix) { inherit self user lib; }).profile;
  theme = profile.theme;
in {
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "CaskaydiaCove Nerd Font Mono";
      bold_font = "auto";
      italic_font = "auto";
      enable_audio_bell = false;
      window_padding_width = 10;
      font_size = 12.0;
      confirm_os_window_close = 0;
    };

    extraConfig = lib.concatStrings [''
      foreground #${theme.pallette.base05}
      backgroud #${theme.pallette.base00}

      selection_foreground #${theme.pallette.base00}
      selection_background #${theme.pallette.base06}
      
      cursor #${theme.pallette.base06}
      cursor_text_color #${theme.pallette.base00}

      url_color #${theme.pallette.base07}
      
      active_border_color #${theme.pallette.base0E}
      inactive_border_color #${theme.pallette.base07}
      bell_border_color #${theme.pallette.base06}

      wayland_titlebar_color system
      macos_titlebar_color system

      active_tabforeground #${theme.pallette.base07}
      active_tab_background #${theme.pallette.base0E}
      inactive_tab_foreground #${theme.pallette.base05}
      inactive_tab_background #${theme.pallette.base01}
      tab_bar_background #${theme.pallette.base07}

      mark1_foreground #${theme.pallette.base00}
      mark1_background #${theme.pallette.base0D}
      mark2_foreground #${theme.pallette.base00}
      mark2_background #${theme.pallette.base0E}
      mark3_foreground #${theme.pallette.base00}
      mark3_background #${theme.pallette.base0C}
      
      color0 #${theme.pallette.base03}
      color8 #${theme.pallette.base04}

      color1 #${theme.pallette.base08}
      color9 #${theme.pallette.base08}

      color2 #${theme.pallette.base0B}
      color10 #${theme.pallette.base0B}

      color3 #${theme.pallette.base0A}
      color11 #${theme.pallette.base0A}
      
      color4 #${theme.pallette.base0D}
      color12 #${theme.pallette.base0D}

      color5 #${theme.pallette.base06}
      color13 #${theme.pallette.base06}

      color6 #${theme.pallette.base0C}
      color14 #${theme.pallette.base0C}

      color7 #${theme.pallette.base05}
      color15 #${theme.pallette.base05}
    ''];
  };
}

