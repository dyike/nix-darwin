## nix-darwin
Nix-darwin setup for (M/Intel) Macs.

## setup
### 0x00 First to setup
- Setup your hostname on your Mac.
```
 sudo scutil --get ComputerName | sudo tee /etc/hostname
```
- Install Nix, multi-user installation.
- Install Homebrew. Not strictly nescessary, but some apps are not in nixpkgs, and nix integrates nicely with homebrew.
Borrow nescessary parts off of the nix-darwin-kickstarter/minimal, and put it in ~/.config/nix-darwin (this repo).
- Install nix-darwin, using nix it self, and nix flakes

```
nix run nix-darwin -- switch --flake ~/.config/nix --impure
```

### 0x01 Build the system and switch to it
> use root!!!
```
sudo darwin-rebuild switch --flake ~/.config/nix --impure
```

## contents
- flake.nix
    - main entrypoint
    - systems configuration: only one for a single mac
    - dependency setup: inputs
- flake.lock
    - pinned versions of all dependencies
- modules/
    - apps.nix: system and homebrew packages
    - host-users.nix: machine and user setup
    - nix-core.nix: configuration of nix itself on the machine
    - system.nix: mac specific settings; dock, keyboard, finder++
- home/
    - home manager modules: user specific package configuration
