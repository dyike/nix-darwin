{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;  # 启用自动补全
    enableAutosuggestions = true;  # 启用自动建议
    # syntaxHighlighting.enable = true;  # 启用语法高亮

    # oh-my-zsh = {
    #   enable = true;
    #   theme = "robbyrussell";
    #   plugins = ["git" "sudo"];
    # };

    # initExtra = ''
    #   # 自定义提示符
    #   export PROMPT="%n@%m:%~%# "

    #   # 别名
    #   alias ll="ls -l"
    #   alias la="ls -A"
    #   alias l="ls -CF"

    #   # 添加自定义路径
    #   export PATH=$HOME/.local/bin:$PATH
    # '';
  };

  # 设置 Zsh 为默认 Shell
  environment.shells = [ pkgs.zsh ];  # 将 Zsh 添加到可用 Shell 列表
  # users.users.${username}.shell = pkgs.zsh;  # 将 `ityike` 替换为你的用户名
}
