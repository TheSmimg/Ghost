{ options, config, pkgs, self, user, lib, ... }: let
  inherit (builtins) elem typeOf;
  inherit (lib) mkIf types;
  inherit (self.options) mkOpt;

  validRolesList = [
    "desktop"
    "server"
  ];
  
  gpuType = config.profile.hardware.gpu;
  cfg = config.profile.role;
in {
  options.profile.role = with types; mkOpt (nullOr str) null;
  
  config = {
    assertions = [
      { assertion = (elem cfg validRolesList); message = "role not valid, roles are ${validRolesList}"; }
    ];

    services.xserver.excludePackages = [ pkgs.xterm ];

    services.xserver.enable = mkIf (cfg == "desktop") true;
    services.xserver.videoDrivers = mkIf (gpuType == "nvidia" && cfg == "desktop") [ "nvidia" ];
  };
}

