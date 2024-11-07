{ options, config, pkgs, self, user, lib, ... }: let
  inherit (builtins) elem typeOf;
  inherit (lib) mkIf types;

  cfg = (elem "pipewire" config.profile.system);
  role = config.profile.role;
in {
  config = {
    assertions = [
      { assertion = ((role == "desktop") && (cfg == true)); message = "Cannot use pipewire without desktop role"; }
    ];

    hardware.pulseaudio.enable = !(cfg);
    security.rtkit.enable = cfg;
    services.pipewire = mkIf (cfg) {
      enable             = true;
      pulse.enable       = true;
      alsa.enable        = true;
      alsa.support32Bit  = true;
    };
  };
}

