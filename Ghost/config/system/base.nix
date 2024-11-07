# ----| Gotta do this because this is a list not a string
{ options, config, pkgs, self, user, lib, ... }: let
  inherit (builtins) elem typeOf;
  inherit (lib) types;
  inherit (self.options) mkOpt;
  cfg = config.profile.system;
in {
  options.profile.system = with types; mkOpt (nullOr (listOf str)) null;
  config = {
    assertions = [
      { assertion = !((typeOf cfg) == null); message = "profile.systems not defined, this is unsupported."; }
    ];
  };
}

