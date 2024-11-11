{ lib, pkgs, self, host, user, inputs, config, ... }: {
  imports = [
    (inputs.impermanence + "/home-manager.nix")
    ./hypr/hypr.nix
    ./apps/kitty.nix
  ];

  fonts.fontconfig.enable = true;

  home = {
    persistence."/nix/dat/home/wisp" = {
      allowOther = true;
      directories = [
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
        ".config/Ryujinx"
        ".ssh"
        ".dots"
      ];
    };

    packages = with pkgs; [
      #----| Internet

      firefox
      vesktop
      zoom-us
      deluge-gtk
      protonvpn-gui

      #----| Media
      
      yt-dlp
      spotify
      
      #----| Games
      
      steam
      ryujinx
      bottles

      #----| Fonts

      (nerdfonts.override { fonts = [ "CascadiaCode" "JetBrainsMono" "Mononoki" "Noto" ]; })
      material-design-icons
      material-symbols
      material-icons
      p7zip
      tor-browser-bundle-bin
    ];
  };

  home.stateVersion = "24.05";
}

