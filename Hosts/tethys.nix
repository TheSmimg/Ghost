{ self, user, lib, ... }: with lib; with builtins; {
  profile = {
    hardware     = {
      cpu        = "amd";
      gpu        = "nvidia";
      monitors   = [{
        output   = "DP-2";
        scale    = 1;
        mode     = "2160x1440@165";
      }];
    };
    system       = [ "zfs" "grub" "plasma" "pipewire" ];
    theme        = null;
    role         = "desktop";
  };

  fileSystems = {
    "/" = {
      device   = "none";
      fsType   = "tmpfs";
      options  = [ "defaults" "mode=775" "size=4G" ];
    };

    "/boot" = {
      device   = "/dev/disk/by-uuid/12CE-A600";
      fsType   = "vfat";
      options  = [ "fmask=0022" "dmask=0022" ];
    };

    "/nix" = {
      device  = "NixOS/nix";
      fsType  = "zfs";
    };

    "/nix/data" = {
      device        = "NixOS/data";
      fsType        = "zfs";
      neededForBoot = true;
    };

    "/nix/data/home" = {
      device        = "NixOS/home";
      fsType        = "zfs";
    };
  };

  environment.persistence."/nix/data" = {
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

  users.users.marley.description = "N. Marley Jacobs";

  system.stateVersion     = "24.05";
  networking.hostId       = "bed2deb0";
  time.timeZone           = "America/New_York";
}

