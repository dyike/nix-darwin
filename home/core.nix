{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    zsh
    zip
    xz
    unzip
    p7zip
    ripgrep
    fzf # A command-line fuzzy finder 
    tree
  ];

  # This is the key part that fixes your issue
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.npm-global/bin"
    "${config.home.homeDirectory}/Code/go/bin"
  ];

  # Properly set up Home Manager to manage your shell environment
  programs.home-manager.enable = true;
  targets.darwin.defaults = {
    NSGlobalDomain.InitialKeyRepeat = 15;
    NSGlobalDomain.KeyRepeat = 2;
  };
}
