{ config, pkgs, lib, username, ... }:
let
  isX86 = pkgs.stdenv.isx86_64;
in {
  home.packages = with pkgs; [
    asitop 
    nodejs_20
    yarn
    # nodePackages.vite
    # nodePackages.pnpm
  ] ++ lib.optionals isX86 [
    go
    gopls       # Go 语言服务器
    delve       # 调试器
    golangci-lint # 代码检查
  ];

  home.sessionVariables = lib.optionalAttrs isX86 {
    GOPATH = "${config.home.homeDirectory}/Code/go";
    GOBIN = "${config.home.homeDirectory}/Code/go/bin";
    GO111MODULE = "on";
  } // {
    # 合并多个路径到 PATH
    PATH = "$HOME/.local/bin:$HOME/.npm-global/bin:$PATH";
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
  };

  home.activation.setupNpmDirs = ''
    mkdir -p $HOME/.npm-global/{lib,bin}
  '';

  programs.zsh = {
    enable = true;
    enableCompletion = true;  # 启用自动补全
    # 启用自动建议
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;  # 启用语法高亮

    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [ "git" "sudo" "z" "history" "extract" ];
    };

    initExtra = ''
      export LC_ALL=en_US.UTF-8

      # 自定义提示符
      autoload -Uz vcs_info
      precmd() { vcs_info }
      zstyle ':vcs_info:git:*' formats '(%F{green}%b%f%F{red}%u%c%f)'
      zstyle ':vcs_info:git:*' actionformats '(%F{green}%b%f|%F{red}%a%f%F{red}%u%c%f)'
      zstyle ':vcs_info:git:*' check-for-changes true
      zstyle ':vcs_info:git:*' unstagedstr '*'
      zstyle ':vcs_info:git:*' stagedstr '+'

      # 第一行：显示用户、主机、路径和 Git 分支
      PROMPT='%F{blue}%n%f@%F{green}%m%f:%F{yellow}%~%f %F{cyan}$vcs_info_msg_0_%f'$'\n'
      # 第二行：输入命令的提示符
      PROMPT+='%F{magenta}➜%f '
      # 右侧提示符：显示时间
      RPROMPT='%F{white}%*%f'

      # 别名
      alias ll="ls -l"
      alias la="ls -A"
      alias l="ls -CF"

    '';
  };
}
