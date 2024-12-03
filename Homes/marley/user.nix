{ lib, pkgs, self, host, user, inputs, config, ... }: {
  imports = [
    (inputs.impermanence + "/home-manager.nix")

    ./zsh.nix
  ];

  fonts.fontconfig.enable = true;

  home = {
    persistence."/nix/persist/home/marley" = {
      allowOther = true;
      directories = [
        "Desktop"
        "Downloads"
        "Documents"
        "Games"
        "Music"
        "Repos"
        "Pictures"
        "Videos"
        ".gnupg"
        ".local/share/keyring"
        ".local/share/direnv"
        ".local/share/Steam"
        ".local/share/bottles"
        ".mozilla"
        ".config/vesktop"
        ".config/sops/age"
        ".ssh"
        ".dots"
      ];
    };

    packages = with pkgs; [
      #----| Utilities

      fastfetch
      p7zip

      #----| Internet

      firefox
      vesktop

      #----| Media

      yt-dlp

      #----| Games

      steam
      bottles

      #----| Fonts

      (nerdfonts.override { fonts = [ "CascadiaCode" "JetBrainsMono" "Mononoki" "Noto" ]; })
      material-design-icons
      material-symbols
      material-icons
    ];
  };

  home.stateVersion = "24.05";
}

