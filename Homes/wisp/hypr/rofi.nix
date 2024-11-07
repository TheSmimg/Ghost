{ lib, pkgs, self, host, user, inputs, config, ... }: let
  profile = ((import ../../../Hosts/${host}.nix) { inherit lib self user; }).profile;
  theme = profile.theme;
  inherit (config.lib.formats.rasi) mkLiteral;
in {
  programs.rofi                 = {
    enable                      = true;
    
    extraConfig                 = {
      show-icons                = mkLiteral "true";
      modi                      = mkLiteral "\"drun,filebrowser,window,run\"";
      display-drun              = mkLiteral "\" \"";
      display-run               = mkLiteral "\" \"";
      display-filebrowser       = mkLiteral "\" \"";
      display-window            = mkLiteral "\" \"";
      drun-display-format       = mkLiteral "\"{name}\"";
      window-format             = mkLiteral "\"{w}{t}\"";
      font                      = mkLiteral "\"JetBrainsMono Nerd Font 10\"";
      icon-theme                = mkLiteral "\"tela-circle-dark\"";
    };
    
    theme = {
      "*"                       = {
        main-bg                 = mkLiteral "#${theme.pallette.base00}";
        main-fg                 = mkLiteral "#${theme.pallette.base05}";
        main-br                 = mkLiteral "#${theme.pallette.base0E}";
        main-ex                 = mkLiteral "#${theme.pallette.base06}";
        select-bg               = mkLiteral "#${theme.pallette.base07}";
        select-fg               = mkLiteral "#${theme.pallette.base01}";

        separatorcolor          = mkLiteral "transparent";
        border-color            = mkLiteral "transparent";
      };

      "window"                  = {
        height                  = mkLiteral "33em";
        width                   = mkLiteral "63em";
        transparency            = mkLiteral "\"real\"";
        fullscreen              = mkLiteral "false";
        enabled                 = mkLiteral "true";
        cursor                  = mkLiteral "\"default\"";
        spacing                 = mkLiteral "0em";
        padding                 = mkLiteral "0em";
        border-color            = mkLiteral "@main-br";
        background-color        = mkLiteral "@main-bg";
        border                  = mkLiteral "3px";
        border-radius           = mkLiteral "6px";
      };

      "mainbox"                 = {
        enabled                 = mkLiteral "true";
        spacing                 = mkLiteral "0em";
        padding                 = mkLiteral "0em";
        orientation             = mkLiteral "horizontal";
        children                = mkLiteral "[ \"dummywall\", \"listbox\" ]";
        background-color        = mkLiteral "transparent";
      };

      "dummywall"               = {
        spacing                 = mkLiteral "0em";
        padding                 = mkLiteral "0em";
        width                   = mkLiteral "37em";
        expand                  = mkLiteral "false";
        orientation             = mkLiteral "horizontal";
        children                = mkLiteral "[ \"mode-switcher\", \"inputbar\" ]";
        background-color        = mkLiteral "transparent";
        background-image        = mkLiteral "url(\"${theme.wallpaper}\", height)";
      };
        
      #----| Mode Switcher |----#

      "mode-switcher"           = {
        orientation             = mkLiteral "vertical";
        enabled                 = mkLiteral "true";
        width                   = mkLiteral "3.8em";
        padding                 = mkLiteral "9.2em 0.5em 9.2em 0.5em";
        spacing                 = mkLiteral "1.2em";
        background-color        = mkLiteral "transparent";
        background-image        = mkLiteral "url(\"${theme.wallpaper}\", height)";
      };

      "button"                  = {
        cursor                  = mkLiteral "pointer";
        border-radius           = mkLiteral "2em";
        background-color        = mkLiteral "@main-bg";
        text-color              = mkLiteral "@main-fg";
      };

      "button selected"         = {
        background-color        = mkLiteral "@main-fg";
        text-color              = mkLiteral "@main-bg";
      };

      #----| Inputs |----#

      "inputbar"                = {
        enabled                 = mkLiteral "true";
        children                = mkLiteral "[ \"entry\" ]";
        background-color        = mkLiteral "transparent";
      };

      "entry"                   = {
        enabled                 = mkLiteral "false";
      };

      #----| Lists |----#

      "listbox"                 = {
        spacing                 = mkLiteral "0em";
        padding                 = mkLiteral "2em";
        children                = mkLiteral "[ \"dummy\", \"listview\", \"dummy\" ]";
        background-color        = mkLiteral "transparent";
      };

      "listview"                = {
        enabled                 = mkLiteral "true";
        spacing                 = mkLiteral "0em";
        padding                 = mkLiteral "0em";
        columns                 = mkLiteral "1";
        lines                   = mkLiteral "8";
        cycle                   = mkLiteral "true";
        dynamic                 = mkLiteral "true";
        scrollbar               = mkLiteral "false";
        layout                  = mkLiteral "vertical";
        reverse                 = mkLiteral "false";
        expand                  = mkLiteral "false";
        fixed-height            = mkLiteral "true";
        fixed-columns           = mkLiteral "true";
        cursor                  = mkLiteral "\"default\"";
        background-color        = mkLiteral "transparent";
        text-color              = mkLiteral "@main-fg";
      };

      "dummy"                   = {
        background-color        = mkLiteral "transparent";
      };

      #----| Elements |----#

      "element"                 = {
        border-radius           = mkLiteral "6px";
        enabled                 = mkLiteral "true";
        spacing                 = mkLiteral "0.8em";
        padding                 = mkLiteral "0.4em 0.4em 0.4em 1.5em";
        cursor                  = mkLiteral "pointer";
        background-color        = mkLiteral "transparent";
        text-color              = mkLiteral "@main-fg";
      };

      "element selected.normal" = {
        background-color        = mkLiteral "@select-bg";
        text-color              = mkLiteral "@select-fg";
      };

      "element-icon"            = {
        size                    = mkLiteral "2.8em";
        cursor                  = mkLiteral "inherit";
        background-color        = mkLiteral "transparent";
        text-color              = mkLiteral "inherit";
      };

      "element-text"            = {
        vertical-align          = mkLiteral "0.5";
        horizontal-align        = mkLiteral "0.0";
        cursor                  = mkLiteral "inherit";
        background-color        = mkLiteral "transparent";
        text-color              = mkLiteral "inherit";
      };

      #----| Errors |----#

      "error-message"           = {
        text-color              = mkLiteral "@main-fg";
        background-color        = mkLiteral "@main-bg";
        text-transform          = mkLiteral "capitalize";
        children                = mkLiteral "[ \"textbox\" ]";
      };

      "textbox"                 = {
        text-color              = mkLiteral "inherit";
        background-color        = mkLiteral "inherit";
        virtical-align          = mkLiteral "0.5";
        horizontal-align        = mkLiteral "0.5";
      };
    };
  };
}

