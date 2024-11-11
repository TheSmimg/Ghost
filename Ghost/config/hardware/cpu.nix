{ options, config, pkgs, self, user, lib, ... }: let
  inherit (builtins) elem typeOf;
  inherit (lib) mkIf types;
  inherit (self.options) mkOpt;
  
  validCpuList = [
    "amd"
    "intel"
    "generic-x86_64"
  ];

  cfg = config.profile.hardware.cpu;
  boot = config.boot;
in {
  options.profile.hardware.cpu = with types; mkOpt (nullOr str) null;

  config = {
    assertions = [
      { assertion = (elem cfg validCpuList); message = "cpu not a valid type, types are: ${validCpuList}"; }
    ];

    hardware.cpu.amd.updateMicrocode   = mkIf (cfg == "amd") true;
    hardware.cpu.intel.updateMicrocode = mkIf (cfg == "intel") true;
  };
}

