{
  description = "Nix for macOS configuration";
  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
    ];
  };

  # This is the standard format for flake.nix. `inputs` are the dependencies of the flake,
  # Each item in `inputs` will be passed as a parameter to the `outputs` function after being pulled and built.
  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";
    nix-darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # The `outputs` function will return all the build results of the flake.
  # A flake can have many use cases and different types of outputs,
  # parameters in `outputs` are defined in `inputs` and can be referenced by their names.
  # However, `self` is an exception, this special parameter points to the `outputs` itself (self-reference)
  # The `@` syntax here is used to alias the attribute set of the inputs's parameter, making it convenient to use inside the function.
  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    ...
  }: let
    # Use SUDO_USER if available (when running with sudo), otherwise fall back to USER
    username =
      if builtins.getEnv "SUDO_USER" != ""
      then builtins.getEnv "SUDO_USER"
      else builtins.getEnv "USER";
    useremail = "yuanfeng634@gmail.com";
    # system = "aarch64-darwin"; # aarch64-darwin or x86_64-darwin
    system = builtins.currentSystem;
    hostname = builtins.replaceStrings ["\n"] [""] (builtins.readFile /etc/hostname);

    specialArgs =
      inputs
      // {
        inherit username useremail hostname;
      };
  in {
    darwinConfigurations."${hostname}" = nix-darwin.lib.darwinSystem {
      inherit system specialArgs;
      modules = [
        ./modules/host-users.nix
        ./modules/nix-core.nix
        ./modules/system.nix
        ./modules/apps.nix

        # home home-manager
        home-manager.darwinModules.home-manager
        {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home;
            home-manager.extraSpecialArgs = specialArgs;
        }
      ];
    };
  };
}
