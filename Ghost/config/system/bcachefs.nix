{ options, config, pkgs, self, user, lib, ... }: let

  inherit (builtins) elem typeOf;
  inherit (lib) mkIf types;

  cfg = (elem "bcachefs" config.profile.system);
in {
  config = {
    boot.supportedFilesystems = [ "bcachefs" ];
  };
}

