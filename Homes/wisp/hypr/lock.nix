{ lib, pkgs, self, host, user, inputs, config, ... }: let
  profile = ((import ../../../Hosts/${host}.nix) { inherit lib self user; }).profile;
  theme = profile.theme;
in {
  programs.swaylock = {
    enable = true;
    settings = {
      daemonize = true;
      image = "${theme.wallpaper}";
      show-failed-attempts = true;
      color = "${theme.pallette.base01}";
      font = "\"Inter\"";
      indicator-radius = 200;
      indicator-thickness = 20;
      line-color = "${theme.pallette.base01}";
      ring-color = "${theme.pallette.base00}";
      inside-color = "${theme.pallette.base01}";
      key-hl-color = "${theme.pallette.base0F}";
      text-color = "${theme.pallette.base07}";
      text-caps-lock-color = "\"\"";
      line-ver-color = "${theme.pallette.base0F}";
      ring-ver-color = "${theme.pallette.base0F}";
      inside-ver-color = "${theme.pallette.base01}";
      text-ver = "${theme.pallette.base07}";
      ring-wrong-color = "${theme.pallette.base08}";
      text-wrong-color = "${theme.pallette.base08}";
      inside-wrong-color = "${theme.pallette.base01}";
      inside-clear-color = "${theme.pallette.base01}";
      text-clear-color = "${theme.pallette.base07}";
      ring-clear-color = "${theme.pallette.base0D}";
      line-clear-color = "${theme.pallette.base01}";
      line-wrong-color = "${theme.pallette.base01}";
      bs-hl-color = "${theme.pallette.base08}";
      ignore-empty-password = true;
    };
  };
}

