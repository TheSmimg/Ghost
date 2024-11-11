{ self, user, lib, ... }: with lib; with builtins; {
  profile    = {
    hardware = {
      cpu = "generic-x86_64";
      gpu = "generic";
      monitors = [{
        output   = "auto";
        scale    = 1;
        mode     = "auto";
      }];
    };
    system   = [ "hyprland" "systemd" ];
    theme    = (import ../Ghost/config/themes/catppuccin/theme.nix);
    role     = "server";
  };
  
  users.users.root.hashedPasswordFile = mkForce null;
  users.users.${user} = {
    hashedPasswordFile = mkForce null;
    initialHashedPassword = "";
  };
  
  boot.supportedFilesystems = [ "bcachefs" ];
}

