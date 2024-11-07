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
    system       = [ "grub" "hyprland" "pipewire" "systemd" "zfs" ];
    theme        = (import ../Ghost/config/themes/catppuccin/theme.nix);
    role         = "desktop";
  };

  boot = {
    initrd.availableKernelModules = [ "nvme" "ahci" "xhci_pci" "usbhid" "uas" "sd_mod" ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-amd" ];
    kernelParams = [ "nvidia_drm.fbdev=1" ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" = {
      device   = "none";
      fsType   = "tmpfs";
      options  = [ "defaults" "mode=775" "size=4G" ];
    };

    "/boot" = {
      device   = "/dev/disk/by-uuid/DBCA-C2E3";
      fsType   = "vfat";
      options  = [ "fmask=0022" "dmask=0022" ];
    };

    "/nix" = {
      device   = "zp/nix";
      fsType   = "zfs";
    };

    "/nix/dat" = {
      device        = "zp/dat";
      fsType        = "zfs";
      neededForBoot = true;
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

  system.stateVersion  = "24.05";
  networking.hostId    = "8752bce0";
  time.timeZone        = "America/New_York";
}

