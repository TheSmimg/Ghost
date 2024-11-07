{ lib }: let
  inherit (lib) mkOption types;
in rec {
  mkOpt     = type: default: mkOption { inherit type default; };
  mkOpt'    = type: default: description: mkOption { inherit type default description; };
  mkBoolOpt = default: description: mkOption { inherit default description; type = with types; bool; };
}

