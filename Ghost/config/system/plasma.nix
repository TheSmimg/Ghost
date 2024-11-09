{ options, config, pkgs, self, user, lib, ... }: let
  inherit (builtins) elem typeOf;
  inherit (lib) mkIf types;

  cfg = (elem "plasma" config.profile.system);
in {
  config = {
    services.displayManager.sddm.enable         = cfg;
    services.displayManager.sddm.wayland.enable = cfg;
    services.desktopManager.plasma6.enable      = cfg;
  };
}

