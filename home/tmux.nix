{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    shell = "/bin/zsh";
    prefix = "C-a";
    baseIndex = 1;
    paneBaseIndex = 1;
    terminal = "screen-256color";
    keyMode = "vi";
    mouse = true;
    customPaneNavigationAndResize = true;
    disableConfirmationPrompt = true;
    escapeTime = 0;
    extraConfig = ''
      # 解除默认前缀绑定
      unbind C-b
      bind-key C-a send-prefix

      # 配置重载快捷键
      bind-key r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded"

      # 打开配置文件
      bind-key M split-window -h "nvim ~/.config/tmux/tmux.conf"

      # 分割面板配置
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # Vim 风格导航
      bind h select-pane -L
      bind l select-pane -R
      bind k select-pane -U
      bind j select-pane -D

      # 无前缀导航
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # Shift 切换窗口
      bind -n S-Left previous-window
      bind -n S-Right next-window

      # 禁用提示音
      set -g visual-activity off
      set -g visual-bell off
      set -g visual-silence off
      setw -g monitor-activity off
      set -g bell-action none

      # 真彩色支持
      set -as terminal-overrides ',xterm*:RGB'
      set -g default-terminal "screen-256color"
    '';
  };
}

