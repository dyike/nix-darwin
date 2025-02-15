{ pkgs, hostname, username, ... }:

#############################################################
#
#  Host & Users configuration
#
#############################################################

{
  networking.hostName = hostname;
  networking.computerName = hostname;
  system.defaults.smb.NetBIOSName = hostname;

  users.users."${username}"= {
    home = "/Users/${username}";
    description = username;
    shell = pkgs.zsh;
  };

  nix.settings.trusted-users = [ username ];
}
