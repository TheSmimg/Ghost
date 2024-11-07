{ options, config, pkgs, self, user, lib, ... }: let
  inherit (builtins) elem typeOf;
  inherit (lib) mkIf types;

  cfg = (elem "systemd" config.profile.system);
in {
  config = {
    boot.initrd.systemd.enable = cfg;
  };
}

