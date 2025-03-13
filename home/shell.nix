{ config, pkgs, lib, username, ... }:
let
  isX86 = pkgs.stdenv.isx86_64;
in {
  home.packages = with pkgs; [
    asitop 
    iperf3
    nodejs_20
    yarn
    nodePackages.pnpm
    go
    gopls       # Go language server
    delve       # Debugger
    golangci-lint # Code checker
  ] ++ lib.optionals isX86 [
    # Additional x86-specific packages if needed
  ];

  # Use Home Manager's proper way to set environment variables
  home.sessionVariables = {
    SHELL = "/etc/profiles/per-user/${username}/bin/zsh";
    GOPATH = "${config.home.homeDirectory}/Code/go";
    GOBIN = "${config.home.homeDirectory}/Code/go/bin";
    GO111MODULE = "on";
    # 合并多个路径到 PATH，只添加必要的路径，尊重系统路径
    PATH = "/etc/profiles/per-user/${username}/bin:$HOME/.local/bin:$HOME/.npm-global/bin:$PATH";
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
  };

  # home.sessionVariables = lib.optionalAttrs isX86 {
  #   # GOPATH = "${config.home.homeDirectory}/Code/go";
  #   # GOBIN = "${config.home.homeDirectory}/Code/go/bin";
  #   # GO111MODULE = "on";
  # } // {
  #   GOPATH = "${config.home.homeDirectory}/Code/go";
  #   GOBIN = "${config.home.homeDirectory}/Code/go/bin";
  #   GO111MODULE = "on";
  #   # 合并多个路径到 PATH
  #   PATH = "$HOME/.local/bin:$HOME/.npm-global/bin:$PATH";
  #   NPM_CONFIG_PREFIX = "$HOME/.npm-global";
  # };

  home.activation.setupNpmDirs = ''
    mkdir -p $HOME/.npm-global/{lib,bin}
  '';

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      save = 10000;
      path = "$HOME/.zsh_history";
      ignoreDups = true;
      share = true;
      expireDuplicatesFirst = true;
    };

    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [ "git" "sudo" "z" "history" "extract" ];
    };

    initExtra = ''
      # Custom prompt
      autoload -Uz vcs_info
      precmd() { vcs_info }
      zstyle ':vcs_info:git:*' formats '(%F{green}%b%f%F{red}%u%c%f)'
      zstyle ':vcs_info:git:*' actionformats '(%F{green}%b%f|%F{red}%a%f%F{red}%u%c%f)'
      
      PROMPT='%F{blue}%n%f@%F{green}%m%f:%F{yellow}%~%f %F{cyan}$vcs_info_msg_0_%f'$'\n'
      PROMPT+='%F{magenta}➜%f '
      RPROMPT='%F{white}%*%f'

      # Aliases
      alias ll="ls -l"
      alias la="ls -A"
      alias l="ls -CF"

      # 确保tmux在所有tab中使用一致的shell
      if [ "$TMUX" != "" ]; then
        export PATH="/etc/profiles/per-user/${username}/bin:$PATH"
      fi
    '';

    envExtra = ''
      # 确保zsh路径一致性
      export PATH="/etc/profiles/per-user/${username}/bin:$PATH"
    '';
  };
}
