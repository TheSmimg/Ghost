{ options, config, pkgs, self, user, lib, ... }: let
  inherit (builtins) elem typeOf;
  inherit (lib) mkIf types;

  cfg = (elem "hyprland" config.profile.system);
in {
  config = {
    programs.hyprland.enable = mkIf (cfg) true;
    programs.dconf.enable    = mkIf (cfg) true;
    services.xserver.displayManager.startx.enable = mkIf (cfg) true;
    security.pam.services.swaylock = mkIf (cfg) {};
  };
}

