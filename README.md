## Multi-Platform Nix Configuration

This configuration automatically sets up a fresh Mac or Linux machine to my personal preferences. It supports both macOS (via nix-darwin) and NixOS with shared configuration modules.

## Platform Support

- **macOS**: Uses nix-darwin with Homebrew for GUI applications
- **NixOS**: Native NixOS configuration with GNOME desktop environment

## Installation Instructions

### macOS Setup

1. **Install Prerequisites**:
   - Install [Homebrew](https://brew.sh)
   - Install git-crypt: `brew install git-crypt`
   - Install Nix via [nix-installer](https://github.com/DeterminateSystems/nix-installer)

1. **Clone and Setup Repository**:
   ```bash
   # Clone to the nix-darwin expected location
   git clone <your-repo-url> ~/.config/nix-darwin
   cd ~/.config/nix-darwin
   ```

1. **Setup Secrets** (Required - configuration will fail without this):
   - Install and sync password manager via Mac App Store
   - Download git-crypt key and place in `.git/git-crypt/keys/default`
   - **Unlock secrets**: `git-crypt unlock`
   - **Verify unlock worked**: `cat .secrets/env-vars.sh` (should show readable content, not binary)

1. **Apply Configuration**:
   ```bash
   nix run nix-darwin -- switch --flake ~/.config/nix-darwin
   ```

### NixOS Setup

1. **Install Prerequisites**:
   ```bash
   # Temporarily install git-crypt (needed before first rebuild)
   nix-shell -p git-crypt git
   ```

1. **Clone and Setup Repository**:
   ```bash
   git clone <your-repo-url> ~/.dotfiles
   cd ~/.dotfiles
   ```

1. **Hardware Configuration**:
   ```bash
   # Generate your actual hardware configuration
   sudo nixos-generate-config --show-hardware-config > hosts/nixos/hardware-configuration.nix
   ```

1. **Setup Secrets** (Required - configuration will fail without this):
   - Install and sync password manager
   - Download git-crypt key and place in `.git/git-crypt/keys/default`
   - **Unlock secrets**: `git-crypt unlock`
   - **Verify unlock worked**: `cat .secrets/env-vars.sh` (should show readable content, not binary)

1. **Enable Flakes** (if not already enabled):
   ```bash
   # Add to /etc/nixos/configuration.nix temporarily:
   nix.settings.experimental-features = [ "nix-command" "flakes" ];
   sudo nixos-rebuild switch
   ```

1. **Apply Configuration**:
   ```bash
   sudo nixos-rebuild switch --flake ~/.dotfiles#meerkat --verbose
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

## Troubleshooting

### Git-crypt Issues

**Problem**: `error: reading file '.secrets/env-vars.sh': No such file or directory`
**Solution**: Secrets haven't been unlocked. Follow the git-crypt setup steps above.

**Problem**: Files in `.secrets/` appear as binary data or gibberish
**Solution**: Run `git-crypt unlock` in the repository root.

**Problem**: `git-crypt: error: unable to decrypt file`
**Solution**: 
1. Ensure you have the correct git-crypt key in `.git/git-crypt/keys/default`
2. Try `git-crypt unlock .git/git-crypt/keys/default`
3. Verify the key file isn't corrupted

**Problem**: Git-crypt not found on NixOS
**Solution**: Install temporarily with `nix-shell -p git-crypt` before first rebuild.

### Key Transfer Security

When transferring the git-crypt key between machines:
1. **Use secure methods**: SCP over SSH, encrypted USB, or secure cloud storage
2. **Delete temporary copies**: Remove the key from intermediate locations after transfer
3. **Verify integrity**: Check the key file size/hash matches the original
4. **Test unlock**: Always verify `git-crypt unlock` works before attempting rebuild

### Resources

- https://medium.com/@zmre/nix-darwin-quick-tip-activate-your-preferences-f69942a93236
- https://davi.sh/til/nix/nix-macos-setup/
- https://blog.6nok.org/how-i-use-nix-on-macos/
- https://github.com/LnL7/nix-darwin
- https://github.com/nix-community/home-manager
- https://github.com/nixypanda/dotfiles
- https://github.com/kubukoz/nix-config/tree/main
