{ self, user, lib, ... }: with lib; with builtins; {
  profile = {
    hardware     = {
      cpu        = "intel";
      gpu        = "nvidia";
      monitors   = [{
        scale    = 1;
        mode     = "3546x2160@60";
      }];
    };
    system       = [ "bcachefs" "grub" "plasma" "pipewire" ];
    theme        = null;
    role         = "desktop";
  };

  hardware.nvidia = {
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
      offload = {
        enable=true;
        enableOffloadCmd = true;
      };
    };
  };

  fileSystems = {
    "/" = {
      device   = "none";
      fsType   = "tmpfs";
      options  = [ "defaults" "mode=775" "size=8G" ];
    };

    "/boot" = {
      device   = "/dev/disk/by-uuid/34B1-E916";
      fsType   = "vfat";
      options  = [ "fmask=0022" "dmask=0022" ];
    };

    "/nix" = {
      device  = "UUID=80435d4a-4203-4a68-8630-0f5b0bbd46b5";
      fsType  = "bcachefs";
      options = [ "compress=lz4" "background_compress=zstd" ];
    };
  };

  environment.persistence."/nix/persist" = {
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
  networking.hostId       = "bed2deb1";
  time.timeZone           = "America/New_York";
}
