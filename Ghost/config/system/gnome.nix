{ options, config, pkgs, self, user, lib, ... }: let
  inherit (builtins) elem typeOf;
  inherit (lib) mkIf types;

  cfg = (elem "gnome" config.profile.system);
in {
  config = {
    services.xserver.displayManager.gdm.enable    = mkIf (cfg) true;
    services.xserver.desktopManager.gnome.enable  = mkIf (cfg) true;
    programs.dconf.enable = mkIf (cfg) true;
  };
}

