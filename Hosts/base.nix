{ options, config, self, user, lib, pkgs, host, ... }: with lib; with self.lib; {
  sops.defaultSopsFile = ../Stash/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/nix/dat/home/${user}/.config/sops/age/keys.txt";
  sops.gnupg.sshKeyPaths = [];

  environment.systemPackages = with pkgs; [
    neovim
    sops
    git
  ];

  environment.variables = {
    GSETTINGS_SCHEMA_DIR="${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";
  };

  boot.loader.grub = mkDefault {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };
  
  sops.secrets."users/${user}/passwd".neededForUsers = true;
  sops.secrets."users/root/passwd".neededForUsers = true;

  users.users.${user} = {
    description         = mkDefault "Jane Doe";
    extraGroups         = mkDefault [ "wheel" ];
    isNormalUser        = true;
    group               = "users";
    home                = "/home/${user}";
    uid                 = 1000;
    hashedPasswordFile  = mkDefault config.sops.secrets."users/${user}/passwd".path;
  };

  users.users.root.hashedPasswordFile = mkDefault config.sops.secrets."users/root/passwd".path;

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  nix = {
    extraOptions = ''
      warn-dirty = false
      http2      = true
    '';
    
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };

    gc = {
      automatic = true;
      dates     = "weekly";
      options   = "--delete-older-than 14d";
    };
  };

  nixpkgs.config.allowUnfree = true;
  programs.fuse.userAllowOther = true;
  networking.networkmanager.enable = true;
  networking.wireless.enable = false;
  hardware.enableRedistributableFirmware  = mkDefault true;
}

