{ self, user, lib, ... }: with lib; with builtins; {
  profile = {
    hardware     = {
      cpu        = "amd";
      gpu        = "nvidia";
      monitors   = [{
        output   = "DP-2";
        scale    = 1;
        mode     = "3440x1440@180";
      }];
    };
    system       = [ "bcachefs" "grub" "hyprland" "pipewire" ];
    theme        = (import ../Ghost/config/themes/catppuccin/theme.nix);
    role         = "desktop";
  };

  fileSystems = {
    "/" = {
      device   = "none";
      fsType   = "tmpfs";
      options  = [ "defaults" "mode=775" "size=4G" ];
    };

    "/boot" = {
      device   = "/dev/disk/by-uuid/B41D-E912";
      fsType   = "vfat";
      options  = [ "fmask=0022" "dmask=0022" ];
    };

    "/nix" = {
      device  = "UUID=1a2b2f5f-a519-47f7-868f-763888e31534";
      fsType  = "bcachefs";
    };
  };

  environment.persistence."/nix/dat" = {
    hideMounts  = true;
    directories = [
      "/var/log"
      "/var/lib/nixos"
      
      "/etc/nixos"
      "/etc/NetworkManager/system-configurations"
    ];
    
    files = [
      "/etc/machine-id"
    ];
  };

  users.users.wisp.description = "Willow Bracker";
  
  system.stateVersion     = "24.05";
  networking.hostId       = "8752bce0";
  time.timeZone           = "America/New_York";
}

