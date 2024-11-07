{ options, config, pkgs, self, user, lib, ... }: let

  inherit (builtins) elem typeOf;
  inherit (lib) mkIf types;

  cfg = (elem "zfs" config.profile.system);
in {
  config = {
    services.zfs.autoScrub.enable  = cfg;
    services.zfs.trim.enable       = cfg;
  };
}

