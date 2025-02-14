{ pkgs, ... }: {
  programs.alacritty = {
    enable = true;
    settings = {
      shell = {
        program = "/bin/zsh";
        args = [ "-l" "-c" "tmux attach || tmux -f ~/.config/tmux/tmux.conf" ];
      };

      window = {
        dimensions = {
          columns = 200;
          lines = 200;
        };
        padding = {
          x = 0;
          y = 0;
        };
        opacity = 0.9;
        option_as_alt = "OnlyLeft";
      };

      scrolling = {
        history = 100000;
        multiplier = 3;
      };

      font = {
        normal = {
          family = "Monaco";
          style = "Regular";
        };
        bold = {
          family = "Monaco";
          style = "Bold";
        };
        italic = {
          family = "Monaco";
          style = "Italic";
        };
        bold_italic = {
          family = "Monaco";
          style = "Bold Italic";
        };
        size = 20.0;
        offset = {
          x = 1;
          y = 10;
        };
        glyph_offset = {
          x = 0;
          y = 5;
        };
      };

      colors = {
        primary = {
          background = "0x282828";
          foreground = "0xebdbb2";
        };
        normal = {
          black = "0x282828";
          red = "0xcc241d";
          green = "0x98971a";
          yellow = "0xd79921";
          blue = "0x458588";
          magenta = "0xb16286";
          cyan = "0x689d6a";
          white = "0xa89984";
        };
        bright = {
          black = "0x928374";
          red = "0xfb4934";
          green = "0xb8bb26";
          yellow = "0xfabd2f";
          blue = "0x83a598";
          magenta = "0xd3869b";
          cyan = "0x8ec07c";
          white = "0xebdbb2";
        };
      };

      hints = {
        enabled = [
          {
            regex = "(https|http):[^\\u0000-\\u001F\\u007F-\\u009F<>\"\\s{-}\\^⟨⟩`]+";
            hyperlinks = true;
            action = "Select";
            command = "open";
            post_processing = true;
            mouse.enabled = true;
          }
          {
            regex = "(file|git|ssh|ftp|ipfs|ipns|magnet|mailto):[^\\u0000-\\u001F\\u007F-\\u009F<>\"\\s{-}\\^⟨⟩`]+";
            hyperlinks = true;
            action = "Select";
            post_processing = true;
            mouse.enabled = true;
          }
        ];
      };

      key_bindings = [
        { key = "I"; mods = "Control"; mode = "~Vi|~Alt"; action = "ScrollLineUp"; }
        { key = "K"; mods = "Control"; mode = "~Vi|~Alt"; action = "ScrollLineDown"; }
        { key = "J"; mods = "Control"; mode = "~Vi|~Alt"; action = "None"; }
        { key = "L"; mods = "Control"; mode = "~Vi|~Alt"; action = "None"; }
        { key = "Back"; mods = "Alt"; chars = "\\x17"; }

        # Vi Mode
        { key = "Space"; mods = "Control"; action = "ToggleViMode"; }
        { key = "Escape"; mode = "Vi|~Search"; action = "ClearSelection"; }
        { key = "I"; mode = "Vi|~Search"; action = "Up"; }
        { key = "I"; mode = "Vi|~Search"; action = "CenterAroundViCursor"; }
        { key = "I"; mods = "Shift"; mode = "Vi|~Search"; action = "Up"; }
        { key = "K"; mode = "Vi|~Search"; action = "Down"; }
        { key = "K"; mode = "Vi|~Search"; action = "CenterAroundViCursor"; }
        { key = "K"; mods = "Shift"; mode = "Vi|~Search"; action = "Down"; }
        { key = "J"; mode = "Vi|~Search"; action = "Left"; }
        { key = "J"; mods = "Shift"; mode = "Vi|~Search"; action = "First"; }
        { key = "L"; mode = "Vi|~Search"; action = "Right"; }
        { key = "L"; mods = "Shift"; mode = "Vi|~Search"; action = "Last"; }
        { key = "G"; mode = "Vi|~Search"; action = "ScrollToTop"; }
        { key = "G"; mods = "Shift"; mode = "Vi|~Search"; action = "ScrollToBottom"; }
        { key = "Y"; mode = "Vi|~Search"; action = "Copy"; }
        { key = "Y"; mode = "Vi|~Search"; action = "ClearSelection"; }
        { key = "V"; mode = "Vi|~Search"; action = "ToggleNormalSelection"; }
        { key = "V"; mods = "Shift"; mode = "Vi|~Search"; action = "ToggleLineSelection"; }
        { key = "V"; mods = "Control"; mode = "Vi|~Search"; action = "ToggleBlockSelection"; }
        { key = "Return"; mode = "Vi|~Search"; action = "Open"; }
        { key = "B"; mode = "Vi|~Search"; action = "SemanticLeft"; }
        { key = "B"; mods = "Shift"; mode = "Vi|~Search"; action = "WordLeft"; }
        { key = "W"; mode = "Vi|~Search"; action = "SemanticRight"; }
        { key = "W"; mods = "Shift"; mode = "Vi|~Search"; action = "WordRight"; }
        { key = "E"; mode = "Vi|~Search"; action = "SemanticRightEnd"; }
        { key = "E"; mods = "Shift"; mode = "Vi|~Search"; action = "WordRightEnd"; }
        { key = "Slash"; mode = "Vi|~Search"; action = "SearchForward"; }
        { key = "Slash"; mods = "Shift"; mode = "Vi|~Search"; action = "SearchBackward"; }
        { key = "N"; mode = "Vi|~Search"; action = "SearchNext"; }
        { key = "N"; mods = "Shift"; mode = "Vi|~Search"; action = "SearchPrevious"; }

        # Search Mode
        { key = "Escape"; mode = "Search"; action = "SearchCancel"; }
        { key = "Return"; mode = "Search|Vi"; action = "SearchConfirm"; }
        { key = "Return"; mode = "Search|~Vi"; action = "SearchFocusNext"; }
        { key = "Return"; mods = "Shift"; mode = "Search|~Vi"; action = "SearchFocusPrevious"; }
        { key = "Back"; mods = "Command"; mode = "Search"; action = "SearchClear"; }
        { key = "Back"; mods = "Alt"; mode = "Search"; action = "SearchDeleteWord"; }
        { key = "I"; mods = "Command"; mode = "Search"; action = "SearchHistoryPrevious"; }
        { key = "K"; mods = "Command"; mode = "Search"; action = "SearchHistoryNext"; }

        # macOS specific
        { key = "R"; mods = "Command"; mode = "~Vi|~Alt"; chars = "\\x0c"; }
        { key = "R"; mods = "Command"; mode = "~Vi|~Alt"; action = "ClearHistory"; }
        { key = "Key0"; mods = "Command"; action = "ResetFontSize"; }
        { key = "Plus"; mods = "Command"; action = "IncreaseFontSize"; }
        { key = "Minus"; mods = "Command"; action = "DecreaseFontSize"; }
        { key = "V"; mods = "Command"; action = "Paste"; }
        { key = "C"; mods = "Command"; action = "Copy"; }
        { key = "C"; mods = "Command"; mode = "Vi|~Search"; action = "ClearSelection"; }
        { key = "H"; mods = "Command"; action = "Hide"; }
        { key = "H"; mods = "Command|Alt"; action = "HideOtherApplications"; }
        { key = "M"; mods = "Command"; action = "Minimize"; }
        { key = "Q"; mods = "Command"; action = "Quit"; }
        { key = "W"; mods = "Command"; action = "Quit"; }
        { key = "N"; mods = "Command"; action = "CreateNewWindow"; }
        { key = "I"; mods = "Command"; mode = "~Vi|~Alt"; chars = "\\x1b[A"; }
        { key = "K"; mods = "Command"; mode = "~Vi|~Alt"; chars = "\\x1b[B"; }
        { key = "J"; mods = "Command"; mode = "~Vi|~Alt"; chars = "\\x01"; }
        { key = "L"; mods = "Command"; mode = "~Vi|~Alt"; chars = "\\x05"; }
        { key = "Back"; mods = "Command"; chars = "\\x15"; }
        { key = "Return"; mods = "Command"; action = "ToggleFullscreen"; }
      ];
    };
  };
}

