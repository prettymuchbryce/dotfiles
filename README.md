## dotfiles

This configuration automatically sets up a fresh Mac or Linux machine to my personal preferences. It supports both macOS (via nix-darwin) and NixOS.

### nix-darwin setup

1. **Prerequisites**:
   - Install [Homebrew](https://brew.sh)
   - Install git-crypt: `brew install git-crypt`
   - Install Nix via [nix-installer](https://github.com/DeterminateSystems/nix-installer).
      - To install the **recommended** vanilla upstream [Nix](https://nixos.org), you will need to explicitly say `no` when prompted to install `Determinate Nix`.
      - Do not use the `--determinate` flag, as it will install the [Determinate](https://docs.determinate.systems/) distribution. By using the determinate distrubtion some nix-darwin functionality that relies on managing the Nix installation, like the `nix.*` options to adjust Nix settings or configure a Linux builder, will be unavailable.
1. Replace contents of `~/.dotfiles` with this repository.
1. Download git-crypt key and move it to `.git/git-crypt/keys/default`.
1. Run `git-crypt unlock .git/git-crypt/keys/default`.
1. Install nix-darwin via `sudo -i nix run nix-darwin -- switch --flake ~/.dotfiles`.

### NixOS setup

1. **Prerequisites**:
   - Temporarily install git-crypt and git via `nix-shell -p git-crypt git`.
1. Replace contents of `~/.dotfiles` with this repository.
1. Download git-crypt key and move it to `/.git/git-crypt/keys/default`.
1. Run `git-crypt unlock .git/git-crypt/keys/default`.
1. Run `sudo nixos-generate-config --show-hardware-config > hosts/nixos/hardware-configuration.nix` to generate hardware configuration.

### Rebuilding the Environment

Just run the alias: `nixrb`

### Manual tasks
- Setup of password manager.
- Create a new SSH key for GitHub, etc. These should be per-machine.
- MacOS settings which aren't supported in nix-darwin
   - Notification Center -> Show previews -> Never
   - Notification Center -> Disable "when display is sleeping"

### Resources
- https://medium.com/@zmre/nix-darwin-quick-tip-activate-your-preferences-f69942a93236
- https://davi.sh/til/nix/nix-macos-setup/
- https://blog.6nok.org/how-i-use-nix-on-macos/
- https://github.com/nix-darwin/nix-darwin
- https://github.com/nix-community/home-manager
- https://github.com/nixypanda/dotfiles
- https://github.com/kubukoz/nix-config/tree/main
