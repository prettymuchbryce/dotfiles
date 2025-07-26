# NixOS configuration for System76 Meerkat

{ config, pkgs, ... }:

{
  imports = [
    # Include the hardware scan results
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "meerkat";
  networking.networkmanager.enable = true;

  # Enable nix-ld for dynamic executables (like fnm-installed Node.js)
  programs.nix-ld.enable = true;

  # Localization
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Wayland and Hyprland
  services.xserver = {
    enable = true;
    videoDrivers = [ "modesetting" ]; # Modern replacement for intel driver
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # ly Display Manager (minimal TUI)
  services.displayManager.ly = {
    enable = true;
    settings = {
      default_input = 2;  # Auto-select password field (username is pre-filled)
      save = true;        # Save username and session
      load = true;        # Load saved username and session
    };
  };
  
  # Set default session to Hyprland
  services.displayManager.defaultSession = "hyprland";

  # XDG Desktop Portal
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # User account
  users.users.bryce = {
    isNormalUser = true;
    description = "bryce";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # Shell configuration
  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Keyboard remapping with keyd
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            home = "C-S-A";
            leftshift = "leftcontrol";
            capslock = "overload(shift, esc)";
            "\\" = "=";
            "=" = "'";
            "'" = "\\";
            rightshift = "'";
            # Mac-style copy/paste shortcuts
            meta = "layer(meta)";
          };
          meta = {
            c = "C-c";  # Super+C -> Ctrl+C (copy)
            v = "C-v";  # Super+V -> Ctrl+V (paste)
          };
        };
      };
    };
  };

  # System packages
  environment.systemPackages = with pkgs; [
    # Core system tools
    vim
    neovim
    git
    unzip # Required by Mason for extracting packages

    # Terminal and shell
    ghostty

    # Web browser
    brave

    # Wayland/Hyprland essentials  
    waybar
    wofi
    wlogout
    pavucontrol # Audio control

    # Additional applications
    docker
    signal-desktop
    slack
    spotify
    telegram-desktop
    vlc
    zoom-us
    discord

    # Development tools
    ollama

    # Clipboard
    wl-clipboard

    # Cursor theme
    bibata-cursors
  ];

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Docker
  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "bryce" ];

  # Enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # System version
  system.stateVersion = "25.05";
}
