## Multi-Platform Nix Configuration

This configuration automatically sets up a fresh Mac or Linux machine to my personal preferences. It supports both macOS (via nix-darwin) and NixOS with shared configuration modules.

## Platform Support

- **macOS**: Uses nix-darwin with Homebrew for GUI applications
- **NixOS**: Native NixOS configuration with GNOME desktop environment

## Installation Instructions

### macOS Setup

1. Replace contents of `~/.config/nix-darwin` with this repository.
1. Install and sync password manager via Mac App Store.
1. Download git-crypt key and place in `.git/git-crypt/keys/default`.
1. Install [Homebrew](https://brew.sh).
1. Install Nix via [nix-installer](https://github.com/DeterminateSystems/nix-installer).
1. Install `nix-darwin` via `nix run nix-darwin -- switch --flake ~/.config/nix-darwin`.

### NixOS Setup

1. Clone this repository to `~/.dotfiles`:
   ```bash
   git clone <your-repo-url> ~/.dotfiles
   cd ~/.dotfiles
   ```

1. Replace the placeholder hardware configuration:
   ```bash
   # Generate your actual hardware configuration
   sudo nixos-generate-config --show-hardware-config > hosts/nixos/hardware-configuration.nix
   ```

1. Install and sync password manager.
1. Download git-crypt key and place in `.git/git-crypt/keys/default`.

1. Enable flakes in your current NixOS configuration (if not already enabled):
   ```bash
   # Add to /etc/nixos/configuration.nix temporarily:
   nix.settings.experimental-features = [ "nix-command" "flakes" ];
   sudo nixos-rebuild switch
   ```

1. Switch to this flake configuration:
   ```bash
   sudo nixos-rebuild switch --flake ~/.dotfiles#meerkat
   ```

## Rebuilding the Environment

The `nixrb` alias works on both platforms:
- **macOS**: `darwin-rebuild switch --flake ~/.dotfiles --verbose`
- **NixOS**: `sudo nixos-rebuild switch --flake ~/.dotfiles#meerkat --verbose`

Just run: `nixrb`

### Both Platforms
* Complete setup of password manager
* Install necessary Brave browser extensions
* Create SSH keys for GitHub (per-machine)
* Follow secret steps in `./.secrets/README.md`

### macOS-specific
* Add application-specific shortcuts via System Preferences → Keyboard → App Shortcuts

### NixOS-specific
* Configure GNOME settings that aren't covered by dconf (if any)
* Set up any additional GNOME extensions through Extensions app

### Resources

- https://medium.com/@zmre/nix-darwin-quick-tip-activate-your-preferences-f69942a93236
- https://davi.sh/til/nix/nix-macos-setup/
- https://blog.6nok.org/how-i-use-nix-on-macos/
- https://github.com/LnL7/nix-darwin
- https://github.com/nix-community/home-manager
- https://github.com/nixypanda/dotfiles
- https://github.com/kubukoz/nix-config/tree/main
