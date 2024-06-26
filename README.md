## Developer Machine Nix Configuration

This configuration automatically sets up a fresh Mac to my personal comfy preferences.

### Installation Instructions

1. Replace contents of `~/.config/nix-darwin` with this repository.
1. Install and sync password manager via Mac App Store.
1. Download git-crypt key and place in `.git/git-crypt/keys/default`.
1. Install [Homebrew](https://brew.sh).
1. Install Nix via [nix-installer](https://github.com/DeterminateSystems/nix-installer).
1. Install `nix-darwin` via `nix run nix-darwin -- switch --flake ~/.config/nix-darwin`.

### Rebuilding the environment

`nixrb`

### Additional Manual steps

Unfortunately not everything is automatable with nix-darwin, so there remains some manual steps.

* Follow instructions in modules/iterm2/README.md (TODO: Automate this).
* Complete setup of password manager.
* Install necessary Brave browser extensions.
* Create a new SSH key for GitHub, etc. These should be per-machine.
* Add application-specific shortcuts via Preferences -> Keyboard -> Keyboard Shortcuts -> App Shortcuts. This is not possible yet from nix-darwin AFAIK.
    * Brave tab left/right
* Follow secret steps in `./.secrets/README.md`

### Resources

- https://medium.com/@zmre/nix-darwin-quick-tip-activate-your-preferences-f69942a93236
- https://davi.sh/til/nix/nix-macos-setup/
- https://blog.6nok.org/how-i-use-nix-on-macos/
- https://github.com/LnL7/nix-darwin
- https://github.com/nix-community/home-manager
- https://github.com/nixypanda/dotfiles
- https://github.com/kubukoz/nix-config/tree/main
