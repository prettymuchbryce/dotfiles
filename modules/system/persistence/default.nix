{
  config,
  pkgs,
  lib,
  collectedPersistence ? {
    system = {
      directories = [ ];
      files = [ ];
    };
    users = { };
  },
  ...
}:

{
  imports = [
    ./helper.nix
  ];
  environment.persistence."/persist" = {
    hideMounts = true;

    # SYSTEM-WIDE PERSISTENCE
    directories = [
      "/var/log"

      # Critical system state
      "/var/lib/nixos" # Prevents UID/GID churn

      # Networking (persistent Wi-Fi/VPN profiles)
      "/etc/NetworkManager/system-connections"

      # Remember login manager usernames
      "/etc/ly"

      # Runtimes
      "/var/lib/docker"
      "/var/lib/flatpak"
      "/var/lib/clamav"

      # DNSCrypt-Proxy (DynamicUser state dir on NixOS)
      "/var/lib/private/dnscrypt-proxy"

      # Secure Boot keys
      "/var/lib/sbctl"
    ]
    ++ (collectedPersistence.system.directories or [ ]);

    files = [
      "/etc/machine-id"
      "/var/lib/systemd/random-seed" # Better entropy across boots
    ]
    ++ (collectedPersistence.system.files or [ ]);

    users.bryce = {
      directories = [
        "Downloads"
        "projects"

        # Credentials & tooling
        ".dotfiles"
        ".ssh"
        ".gnupg"
        ".aws"
        ".docker"
        ".compose-cache"
        ".npm"

        # Dev toolchains (Rust)
        ".cargo"
        ".rustup"

        # Browsers & apps (persist sign-in/profile if desired)
        ".config/google-chrome"
        ".config/nvim"
        ".zoom"
        ".claude"

        # Flatpak app configs
        ".var/app"

        # Editor/app DATA (configs come from Nix/Home Manager)
        ".local/share/nvim"
        ".local/share/flatpak"
        ".local/share/zsh"
        ".local/share/fnm"
        ".local/share/atuin"

        # Node version manager caches
        ".cache/fnm"
        ".cache/zellij"
        ".cache/google-chrome"
        ".cache/nvim"
      ]
      ++ (collectedPersistence.users.bryce.directories or [ ]);
      files = [
        ".claude.json"
        ".claude.json.backup"
        ".zsh_history"
        ".zshrc.local"
        ".gitconfig"
        ".warprc"
      ]
      ++ (collectedPersistence.users.bryce.files or [ ]);
    };
  };

  # Ensure /persist/nix exists (important after fresh formats)
  systemd.tmpfiles.rules = [
    "d /persist/nix 0755 root root -"
  ];
}
