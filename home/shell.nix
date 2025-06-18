{ config, pkgs, lib, username, ... }:
let
  isX86 = pkgs.stdenv.isx86_64;
  unstable = import (fetchTarball https://nixos.org/channels/nixpkgs-unstable/nixexprs.tar.xz) { };
in {
  home.packages = with pkgs; [
    asitop 
    iperf3
    unstable.nodejs
    unstable.yarn
    unstable.nodePackages.pnpm
    unstable.python311
    unstable.python311Packages.uv
    go
    gopls       # Go language server
    delve       # Debugger
    golangci-lint # Code checker
    unstable.rustup        # Rust toolchain installer
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

    initContent = ''
      # Custom prompt with enhanced Git status
      autoload -Uz vcs_info
      zstyle ':vcs_info:*' enable git
      zstyle ':vcs_info:*' check-for-changes true
      zstyle ':vcs_info:*' unstagedstr '!'
      zstyle ':vcs_info:*' stagedstr '+'
      zstyle ':vcs_info:git:*' formats ' %F{cyan}(%F{green}%b%f%F{yellow}%u%c%f%F{cyan})%f'
      zstyle ':vcs_info:git:*' actionformats ' %F{cyan}(%F{green}%b%f|%F{red}%a%f%F{yellow}%u%c%f%F{cyan})%f'
      
      # Add git status symbols
      function git_prompt_status() {
        local symbols=""
        local git_status=$(git status --porcelain 2>/dev/null)
        
        # Untracked files
        if echo "$git_status" | grep -q '?? '; then
          symbols+="%F{red}?%f"
        fi
        
        # Stashed changes
        if git rev-parse --verify refs/stash &>/dev/null; then
          symbols+="%F{yellow}$%f"
        fi
        
        # Ahead/behind remote
        local ahead_behind=$(git rev-list --count --left-right @{upstream}...HEAD 2>/dev/null)
        if [[ -n "$ahead_behind" ]]; then
          local ahead=$(echo "$ahead_behind" | awk '{print $2}')
          local behind=$(echo "$ahead_behind" | awk '{print $1}')
          
          if [[ $ahead -gt 0 && $behind -gt 0 ]]; then
            symbols+="%F{magenta}⇕%f"
          elif [[ $ahead -gt 0 ]]; then
            symbols+="%F{green}↑%f"
          elif [[ $behind -gt 0 ]]; then
            symbols+="%F{red}↓%f"
          fi
        fi
        
        echo "$symbols"
      }
      
      precmd() { 
        vcs_info 
      }
      
      # Define the prompt
      setopt PROMPT_SUBST
      PROMPT='%F{blue}%n%f@%F{green}%m%f:%F{yellow}%~%f$vcs_info_msg_0_$(git_prompt_status)'$'\n'
      PROMPT+='%F{magenta}➜%f '
      RPROMPT='%F{white}%*%f'

      bindkey -s '^R' 'clear\n'

      # Aliases
      alias ll="ls -l"
      alias la="ls -A"
      alias l="ls -CF"
      # Go 环境别名，使原始的 go 命令使用我们的环境选择脚本
      alias go="goenv"
    '';

    envExtra = ''
      export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"
      export NPM_CONFIG_PREFIX="$HOME/.npm-global"
      export SHELL="/etc/profiles/per-user/${username}/bin/zsh"
      
      # Ensure Git uses English
      export LANG=en_US.UTF-8
      export LC_ALL=en_US.UTF-8
      
      # Comprehensive PATH configuration
      export PATH="/etc/profiles/per-user/${username}/bin:$HOME/.local/bin:$HOME/.npm-global/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$HOME/.nix-profile/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
    '';
  };
}
