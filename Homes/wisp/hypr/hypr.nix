{ lib, pkgs, self, host, user, inputs, config, ... }: let
  profile = ((import ../../../Hosts/${host}.nix) { inherit self user lib; }).profile;
  theme = profile.theme;
  monitors = profile.hardware.monitors;
in {
  imports = [ ./rofi.nix ./lock.nix ./wbar.nix ];
  home.packages = with pkgs; [
    swww
    polkit
    polkit_gnome
  ];
  
  home = {
    pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 16;
      x11.enable = true;
      gtk.enable = true;
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Tela-circle-dark";
      package = pkgs.tela-circle-icon-theme;
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;

    extraConfig = let
      modKey  = "SUPER";
      monitor = (builtins.elemAt monitors 0);
      cursor  = "Bibata-Modern-Ice";

      # TODO(Alot of this should also be in a theme module! will look into soon :3)
      # TODO(A lot of this should eventually be moved into profiles, (e.g monitor config))
    in lib.concatStrings [''
      #----| Base Config |----#

      monitor = ${monitor.output},${monitor.mode},auto,${builtins.toString monitor.scale}
      
      misc {
        vrr = 0
        disable_hyprland_logo = true
        disable_splash_rendering = true
        force_default_wallpaper = 0
      }

      cursor:no_hardware_cursors = true

      #----| Environment |----#

      env = LIBVA_DRIVER_NAME,nvidia
      env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      env = __GL_VRR_ALLOWED,1
      env = WLR_DRM_NO_ATOMIC,1

      env = XDG_CURRENT_DESKTOP,Hyprland
      env = XDG_SESSION_DESKTOP,Hyprland
      env = XDG_SESSION_TYPE,wayland
      env = MOZ_ENABLE_WAYLAND,1
      env = QT_AUTO_SCREEN_SCALE_FACTOR,1
      env = GDK_SCALE,1
      
      env = XCURSOR_SIZE,16

      #----| Layouts |----#

      dwindle {
        pseudotile = yes
        preserve_split = yes
      }

      master {
        new_status = master
      }

      general:layout = dwindle
      
      #----| Animations |----#

      animations {
        enabled = yes
        bezier = wind, 0.05, 0.9, 0.1, 1.05
        bezier = winIn, 0.1, 1.1, 0.1, 1.1
        bezier = winOut, 0.3, -0.3, 0, 1
        bezier = liner, 1, 1, 1, 1
        animation = windows, 1, 6, wind, slide
        animation = windowsIn, 1, 6, winIn, slide
        animation = windowsOut, 1, 5, winOut, slide
        animation = windowsMove, 1, 5, wind, slide
        animation = border, 1, 1, liner
        animation = borderangle, 1, 30, liner, loop
        animation = fade, 1, 10, default
        animation = workspaces, 1, 5, wind
      }
      
      #----| Keybinds |----#

      bind = ${modKey}, Q, killactive
      bind = ${modKey}, Delete, exit
      bind = ${modKey}, W, togglefloating
      bind = ${modKey}, G, togglegroup
      bind = ${modKey}, F, fullscreen
      
      bind = ${modKey}, Return, exec, ${pkgs.kitty}/bin/kitty
      bind = ${modKey}, L, exec, ${pkgs.swaylock}/bin/swaylock
      bind = ${modKey}, Space, exec, ${pkgs.procps}/bin/pkill -x rofi || ${pkgs.rofi}/bin/rofi -show drun
      bind = ${modKey}+Shift, W, exec, ${pkgs.killall}/bin/killall .waybar-wrapped || ${pkgs.waybar}/bin/waybar
      
      bind = ${modKey}, 1, workspace, 1
      bind = ${modKey}, 2, workspace, 2
      bind = ${modKey}, 3, workspace, 3
      bind = ${modKey}, 4, workspace, 4

      bind = ${modKey}, mouse_down, workspace, e+1
      bind = ${modKey}, mouse_up, workspace, e-1

      bind = ${modKey}, Left, movefocus, l
      bind = ${modKey}, Right, movefocus, r
      bind = ${modKey}, Up, movefocus, u
      bind = ${modKey}, Down, movefocus, d

      bind = ${modKey}+Shift, 1, movetoworkspacesilent, 1
      bind = ${modKey}+Shift, 2, movetoworkspacesilent, 2
      bind = ${modKey}+Shift, 3, movetoworkspacesilent, 3
      bind = ${modKey}+Shift, 4, movetoworkspacesilent, 4

      bindm = ${modKey}, mouse:272, movewindow
      bindm = ${modKey}, mouse:273, resizewindow
      
      #----| Fonts |----#

      exec = ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface font-name 'Cantarell 10'
      exec = ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface document-font-name 'Cantarell 10'
      exec = ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface monospace-font-name 'JetbrainsMono 9'
      exec = ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface font-antialiasing 'rgba'
      exec = ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface font-hinting 'full'

      #----| Window Rules |----#
      
      windowrulev2 = opacity 0.90 0.90, class:^(firefox)$
      windowrulev2 = opacity 0.80 0.80, class:^(kitty)$

      #----| Theming |----#

      general {
        gaps_in = 3
        gaps_out = 8
        border_size = 2
        col.active_border = rgba(${theme.pallette.base0E}ff) rgba(${theme.pallette.base08}ff) 45deg
        col.inactive_border = rgba(${theme.pallette.base00}ff) rgba(${theme.pallette.base01}ff) 45deg
        layout = dwindle
	resize_on_border = true
      }

      exec = ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
      exec = ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface icon-theme 'Tela-circle-dark'

      #----| Autostart |----#

      #exec-once = ${pkgs.dunst}/bin/dunst
      exec-once = ${pkgs.waybar}/bin/waybar
      exec-once = ${pkgs.hyprpaper}/bin/hyperpaper
      exec-once = ${pkgs.hyprland}/bin/hyprctl setcursor ${cursor} 16
      exec-once = ${pkgs.swww}/bin/swww-daemon
      exec = ${pkgs.swww}/bin/swww img ${theme.wallpaper}
    ''];
  };
}

