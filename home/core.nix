{ pkgs, ... }: {
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
}
