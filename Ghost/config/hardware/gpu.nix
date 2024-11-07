{ options, config, pkgs, self, user, lib, ... }: let
  inherit (builtins) elem typeOf;
  inherit (lib) mkIf types;
  inherit (self.options) mkOpt;
  
  validGpuList = [
    "amd"
    "nvidia"
  ];
  
  cfg = config.profile.hardware.gpu;
in {
  options.profile.hardware.gpu = with types; mkOpt (nullOr str) null;

  config = {
    assertions = [
      { assertion = (elem cfg validGpuList); message = "gpu is not a valid type, types are: ${validGpuList}"; }
    ];
    
    hardware.graphics = mkIf (cfg != "none") {
      enable = true;
      enable32Bit = true;
    };

    hardware.nvidia = mkIf (cfg == "nvidia") {
      modesetting.enable = true;
      nvidiaSettings = false;
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };
  };
}

