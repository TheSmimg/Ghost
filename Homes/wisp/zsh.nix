{ lib, pkgs, self, host, user, inputs, config, ... }: {
  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = ''
      # -*- sh -*- vim:set ft=sh ai et sw=2 sts=2:
      autoload -U colors && colors
      PROMPT='main :: () -> Result<Void()> = '
      '';
    };
  };
}

