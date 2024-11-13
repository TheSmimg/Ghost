{ lib, pkgs, self, host, user, inputs, config, ... }: let
  lambda-theme = builtins.toFile "lambda-theme.zsh-theme" ''
  local ret_status="%(?:%{$fg_bold[green]%}λ :%{$fg_bold[red]%}λ %s)"
      
  function get_pwd() {
    git_root=$PWD
    while [[  $git_root != / && ! -e $git_root.git ]]; do
      git_root=$git_root:h
    done

    if [[ $git_root = / ]]; then
      unset git_root
      prompt_short_dir=%~
    else
      parent=$\{git_root%\/*}
      prompt_short_dir=$\{PWD#$parent/}
    fi
    echo $prompt_short_dir
  }

  PROMPT='$ret_status %{$fg[white]%}$(get_pwd) $(git_prompt_info)%{$reset_color%}%{$reset_color%} '
  ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}"
  ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
  ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[yellow]✗%{$reset_color%}"
  ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]✓%{$reset_color%}"
  '';
  
  custom-zsh-themes = pkgs.stdenv.mkDerivation {
    name = "custom-zsh-themes";
    
    phases = [ "buildPhase" ];
    buildPhase = ''
      mkdir -p $out/themes
      cp ${lambda-theme} $out/themes/lambda-theme.zsh-theme
    '';
  };
in {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable  = true;
      plugins = [ "git" ];
      theme   = "lambda-theme";
      custom  = "${custom-zsh-themes}";
    };
  };
}

