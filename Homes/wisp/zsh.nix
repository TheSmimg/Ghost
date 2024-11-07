{ lib, pkgs, self, host, user, inputs, config, ... }: {
  programs.zsh = {
    enable = true;

    plugins = [{
      name = "powerlevel10k";
      src = pkgs.zsh-powerlevel10k;
      file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    };

    {
      name = "p10k";
      src = ./apps/zsh;
      file = "p10k.zsh";
    };
    ];

    oh-my-zsh = {
      
    };
  };
}

