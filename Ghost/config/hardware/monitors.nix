{ options, config, pkgs, self, user, lib, ... }: let
  inherit (builtins) elem typeOf;
  inherit (lib) mkIf types;
  inherit (self.options) mkOpt;

  cfg = config.profile.hardware.monitors;
in {
  options.profile.hardware.monitors = with types; mkOpt (nullOr (listOf str)) null;
  # TODO(we do not do anything ourselves with this info, this is for wms)
}

