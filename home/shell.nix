{ pkgs, username, ... }: {
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
      export PROMPT="%n@%m:%~%# "

      # 别名
      alias ll="ls -l"
      alias la="ls -A"
      alias l="ls -CF"
    '';
  };

  home.sessionVariables = {
    PATH = "$HOME/.local/bin:$PATH";
  };
}
