{ options, config, pkgs, self, user, lib, ... }: let
  inherit (builtins) elem typeOf;
  inherit (lib) mkIf types;
  inherit (self.options) mkOpt;

  cfg = config.profile.theme;
in {
  options.profile.theme = with types; mkOpt (nullOr attrs) null;
  config = {
    assertions = [ { assertion = (typeOf cfg != null); message = "no theme defined"; } ];
  };
}

