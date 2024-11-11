{ options, config, pkgs, self, user, lib, ... }: let
  inherit (builtins) elem typeOf;
  inherit (lib) mkIf types;

  cfg = (elem "hyprland" config.profile.system);
in {
  config = {
    programs.hyprland.enable = mkIf (cfg) true;
    programs.dconf.enable    = mkIf (cfg) true;
    services.xserver.displayManager.startx.enable = mkIf (cfg) true;
    security.pam.services.swaylock = mkIf (cfg) {};
    security.polkit.enable = mkIf (cfg) true;
    
    systemd.user.services.polkit-gnome-authentication-agent-1 = mkIf (cfg) {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}

