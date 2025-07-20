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

  # X11 and GNOME
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    videoDrivers = [ "modesetting" ]; # Modern replacement for intel driver
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # User account
  users.users.bryce = {
    isNormalUser = true;
    description = "bryce";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

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
            leftshift = "leftcontrol";
            capslock = "overload(shift, esc)";
            home = "C-A-S";
            "\\" = "=";
            "=" = "'";
            "'" = "\\";
            rightshift = "'";
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
    
    # Terminal and shell
    ghostty
    
    # Web browser
    brave
    
    # Application launcher (Raycast alternative)
    ulauncher
    
    # Pop Shell for tiling window management
    gnomeExtensions.pop-shell
    
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
  ];

  # Docker
  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "bryce" ];

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # System version
  system.stateVersion = "25.05";
}