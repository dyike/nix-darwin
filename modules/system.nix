{ pkgs, lib, username, ... }:

{
  # Fix root user home directory assertion with force override
  users.users.root.home = lib.mkForce "/var/root";

  system = {
    stateVersion = 5;

    # Set the primary user for system-wide activation
    primaryUser = username;

    keyboard.enableKeyMapping = true;
    keyboard.remapCapsLockToControl = true;

    defaults = {
      # clock 
      menuExtraClock.Show24Hour = true;  # show 24 hour clock
      # menuExtraClock.ShowSeconds = true;

      # https://github.com/LnL7/nix-darwin/blob/master/modules/system/defaults/trackpad.nix
      trackpad = {
        # tap to click
        Clicking = true;
        # tap-tap-drag to drag
        Dragging = true;
        # two-finger-tap right click
        TrackpadRightClick = true;
      };

      # customize dock
      dock = {
        autohide = false;
        show-recents = false;  # disable recent apps
        tilesize = 32;
        largesize = 96;

        # customize Hot Corners(触发角, 鼠标移动到屏幕角落时触发的动作)
        # wvous-tl-corner = 2;  # top-left - Mission Control
        # wvous-tr-corner = 13;  # top-right - Lock Screen
        wvous-bl-corner = 3;  # bottom-left - Application Windows
        wvous-br-corner = 4;  # bottom-right - Desktop
      };

      # finder
      finder = {
        # bottom status bar
        ShowStatusBar = true;
        ShowPathbar = true;

        # default to list view
        FXPreferredViewStyle = "Nlsv";
        # full path in window title
        _FXShowPosixPathInTitle = true;
      };

    };
  };

  # Add ability to used TouchID for sudo authentication (updated syntax)
  security.pam.services.sudo_local.touchIdAuth = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  # this is required if you want to use darwin's default shell - zsh
  programs.zsh = {
    enable = true;
  };
}
