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
    '';

    envExtra = ''
      export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"
      export NPM_CONFIG_PREFIX="$HOME/.npm-global"
      export SHELL="/etc/profiles/per-user/${username}/bin/zsh"
      export GOPATH="${config.home.homeDirectory}/Code/go"
      export GOBIN="${config.home.homeDirectory}/Code/go/bin"
      export GO111MODULE="on"
      
      # Comprehensive PATH configuration
      export PATH="/etc/profiles/per-user/${username}/bin:$HOME/.local/bin:$HOME/Code/go/bin:$HOME/.npm-global/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$HOME/.nix-profile/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/go/bin:$PATH"
    '';
  };

  # 注释掉了旧的配置
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
}
