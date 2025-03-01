{ username, ... }: {
  imports = [
    ./core.nix
    ./nvim.nix
    ./shell.nix
    ./git.nix
    ./tmux.nix
    ./alacritty.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = username;
    homeDirectory = "/Users/${username}";
    stateVersion = "24.11";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
