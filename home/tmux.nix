{ pkgs, username, ... }: {
  programs.tmux = {
    enable = true;
    shell = "/etc/profiles/per-user/${username}/bin/zsh";
    prefix = "C-a";
    baseIndex = 1;
    # paneBaseIndex = 4;
    terminal = "screen-256color";
    keyMode = "vi";
    mouse = true;
    customPaneNavigationAndResize = true;
    disableConfirmationPrompt = true;
    escapeTime = 0;
    extraConfig = ''
      # 使用login shell并加载tmux环境配置
      set -g default-command "/etc/profiles/per-user/${username}/bin/zsh -c 'test -f ~/.config/tmux/tmux-env.sh && source ~/.config/tmux/tmux-env.sh; exec /etc/profiles/per-user/${username}/bin/zsh -l'"
      
      # 新窗口和面板分割时加载环境配置
      bind c new-window -c "#{pane_current_path}" "/etc/profiles/per-user/${username}/bin/zsh -c 'test -f ~/.config/tmux/tmux-env.sh && source ~/.config/tmux/tmux-env.sh; exec /etc/profiles/per-user/${username}/bin/zsh -l'"
      
      # 配置重载快捷键
      bind-key r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded"

      # 打开配置文件
      bind-key M split-window -h "nvim ~/.config/tmux/tmux.conf"

      # 分割面板配置
      bind | split-window -h -c "#{pane_current_path}" "/etc/profiles/per-user/${username}/bin/zsh -c 'test -f ~/.config/tmux/tmux-env.sh && source ~/.config/tmux/tmux-env.sh; exec /etc/profiles/per-user/${username}/bin/zsh -l'"
      bind - split-window -v -c "#{pane_current_path}" "/etc/profiles/per-user/${username}/bin/zsh -c 'test -f ~/.config/tmux/tmux-env.sh && source ~/.config/tmux/tmux-env.sh; exec /etc/profiles/per-user/${username}/bin/zsh -l'"
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

