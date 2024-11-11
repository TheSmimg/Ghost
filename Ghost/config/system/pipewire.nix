{ options, config, pkgs, self, user, lib, ... }: let
  inherit (builtins) elem typeOf;
  inherit (lib) mkIf types;

  cfg = (elem "pipewire" config.profile.system);
  role = config.profile.role;
in {
  config = {
    assertions = lib.mkIf (cfg) [{ assertion = ((role == "desktop") && (cfg == true)); message = "Cannot use pipewire without desktop role"; }];

    security.rtkit.enable = true;
    hardware.pulseaudio.enable = mkIf (cfg) false;
    services.pipewire = mkIf (cfg) {
      enable             = (cfg);
      pulse.enable       = (cfg);
      alsa.enable        = (cfg);
      alsa.support32Bit  = (cfg);
    };
  };
}

