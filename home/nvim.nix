{ pkgs, ... }: {
  programs = {
    # modern vim
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };
  };
  xdg.configFile."nvim" = {
    source = builtins.fetchGit {
      url = "https://github.com/dyike/nvimrc.git";
    #   ref = "master";
    };
    recursive = true;
  };
}