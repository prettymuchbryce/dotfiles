{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    # Include the hardware scan results
    ./hardware-configuration.nix
    # Platform-specific modules
    ../../modules/system/persistence
    ./ephemeral-root.nix
    ../../modules/system/chromium.nix
    ../../modules/system/fonts.nix
    ../../modules/system/flatpak.nix
    ../../modules/system/opensnitch
    ../../modules/system/dnscrypt-proxy.nix
    ../../modules/system/antivirus.nix
    ../../modules/system/syncthing.nix
  ];

  # Boot configuration and various kernel hardening
  boot = {
    # Enable systemd in initrd
    initrd.systemd.enable = true;

    # Bootloader configuration
    loader = {
      systemd-boot = {
        enable = lib.mkForce false;
        configurationLimit = 20;
      };
      efi.canTouchEfiVariables = true;
    };

    # Enable Lanzaboote for Secure Boot
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    # Kernel command-line parameters
    kernelParams = [
      # Temp debugging.
      "systemd.debug_shell=1"

      # Disables merging of slab caches; small RAM overhead, better type isolation
      "slab_nomerge"

      # Zero-initialize heap memory on allocation; slight CPU overhead
      "init_on_alloc=1"

      # Zero pages on free; more overhead than init_on_alloc, best leak hardening
      "init_on_free=1"

      # Randomizes free page selection; cheap entropy against heap grooming
      "page_alloc.shuffle=1"

      # Force Page Table Isolation (Meltdown); minor perf hit, safest on Intel
      "pti=on"

      # Randomize kernel stack offset on syscall entry; negligible overhead
      "randomize_kstack_offset=on"

      # Kill legacy vsyscall ABI; only affects very old 32-bit static binaries
      "vsyscall=none"

      # Disable debugfs entirely; most desktop users don't need it
      "debugfs=off"

      # Panic on kernel oops to avoid continuing in a compromised state
      # (consider also setting kernel.panic to auto-reboot after N seconds)
      "oops=panic"

      # CPU vulnerability mitigations
      # Spectre v2 + SSB
      "spectre_v2=on"
      "spec_store_bypass_disable=prctl" # or: on | seccomp

      # TAA / TSX
      "tsx=off"
      "tsx_async_abort=full" # drop ",nosmt" unless you want HT off

      # MDS & L1TF
      "mds=full"
      "l1tf=flush" # consider "full,force" only for untrusted VMs

      # KVM host (harmless if you don't run VMs)
      "kvm.nx_huge_pages=force"
    ];

    # Blacklisted kernel modules for security hardening
    blacklistedKernelModules = [
      # Legacy / niche network protocols
      "dccp"
      "sctp"
      "rds"
      "tipc"
      "n_hdlc"
      "ax25"
      "netrom"
      "x25"
      "rose"
      "decnet"
      "econet"
      "af_802154"
      "ipx"
      "appletalk"
      "psnap"
      "p8023"
      "p8022"
      "can"
      "atm"

      # Filesystems you're sure you don't need
      "cramfs"
      "freevxfs"
      "jffs2"
      "gfs2"
      "ksmbd"

      # V4L2 test device
      "vivid"
    ];

    # Kernel sysctl parameters
    kernel.sysctl = {
      # Auto-reboot 30s after a panic
      "kernel.panic" = 30;
      "kernel.panic_on_oops" = 1; # matches oops=panic (belt & suspenders)

      # Hide kernel pointer addresses from userspace (prevents info leaks from /proc, dmesg formats, etc.).
      "kernel.kptr_restrict" = 2;

      # Only root can read the kernel ring buffer (dmesg); reduces info leakage.
      # You'll need sudo for `dmesg` when debugging.
      "kernel.dmesg_restrict" = 1;

      # Lower console log verbosity (first number = active console level). Cuts boot/tty spam;
      # logs still go to journald. Needs to be a space-separated string.
      "kernel.printk" = "3 3 3 3";

      # Disallow unprivileged use of the bpf() syscall. Good hardening; breaks unprivileged eBPF tools.
      # Run such tools with the needed capabilities if you use them.
      "kernel.unprivileged_bpf_disabled" = 1;

      # Harden the eBPF JIT (constant blinding) for everyone. Small perf cost; strong mitigation.
      "net.core.bpf_jit_harden" = 2;

      # Don't auto-load TTY line discipline modules (a historic attack surface). Low breakage risk
      # unless you use niche PPP/serial ldiscs.
      "dev.tty.ldisc_autoload" = 0;

      # Disable userfaultfd for unprivileged processes (removes a common exploit primitive).
      # Rarely needed on desktops; could affect CRIU/advanced VM migration tooling.
      "vm.unprivileged_userfaultfd" = 0;

      # Disable kexec after boot (prevents loading a new kernel from userspace). One-way until reboot.
      # Only an issue if you rely on kexec fast reboots or kdump.
      "kernel.kexec_load_disabled" = 1;

      # Allow only "keyboard control" SysRq actions (SAK/unraw). For maximum lock-down set 0 to disable all.
      # Keep >0 if you like having limited emergency SysRq.
      "kernel.sysrq" = 4;

      # Most restrictive perf; blocks nearly all user-space profiling unless privileged.
      # If you profile occasionally, consider 2 instead of 3.
      "kernel.perf_event_paranoid" = 2;
    };
  };

  # Hardware configuration - firmware and microcode updates
  hardware = {
    enableAllFirmware = true;
    cpu.intel.updateMicrocode = true; # for Intel CPUs
  };

  # Networking
  networking.hostName = "meerkat";
  networking.networkmanager.enable = true;

  # Firewall - deny incoming, allow outgoing
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ]; # No global TCP ports open
    allowedUDPPorts = [ ]; # No incoming UDP ports open by default

    # Ports opened for local network only
    interfaces.enp46s0.allowedTCPPorts = [
      5900 # VNC
      22000 # Syncthing
    ];
    interfaces.enp46s0.allowedUDPPorts = [
      21027 # Syncthing discovery
      22000 # Syncthing QUIC
    ];
  };

  # Enable nix-ld for dynamic executables (like fnm-installed Node.js)
  programs.nix-ld.enable = true;

  # Enable AppArmor with enforcement
  security.apparmor = {
    enable = true;
    killUnconfinedConfinables = true;
  };

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    persistent = true;
    options = "--delete-older-than 30d";
  };

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

  # System services configuration
  services = {
    dbus.implementation = "broker";
    logrotate.enable = true;
    journald = {
      upload.enable = false;
      extraConfig = ''
        SystemMaxUse=500M
        SystemMaxFileSize=50M
      '';
    };
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
      default_input = 2; # Auto-select password field (username is pre-filled)
      save = true; # Save username and session
      load = true; # Load saved username and session
    };
  };

  # Set default session to Hyprland
  services.displayManager.defaultSession = "hyprland";

  # XDG Desktop Portal
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk # For Flatpak integration
    ];
  };

  # User account
  users.mutableUsers = false;
  users.users.bryce = {
    isNormalUser = true;
    description = "bryce";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    hashedPassword = import ../../.secrets/bryce-hash.nix;
  };

  # Shell configuration
  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Environment variables
  environment.sessionVariables = {
    # Enable native Wayland support for Chromium-based browsers
    NIXOS_OZONE_WL = "1";
  };

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
            equal = "grave";
            backslash = "equal";
            apostrophe = "backslash";
            rightshift = "apostrophe";

            # Mac-style copy/paste shortcuts
            meta = "layer(meta)";
          };
          meta = {
            c = "C-c"; # Super+C -> Ctrl+C (copy)
            v = "C-v"; # Super+V -> Ctrl+V (paste)
          };
        };
      };
    };
  };

  security = {
    # Adds hardening so the running kernel can’t be replaced without a reboot: it sets nohibernate (disables hibernation, which could otherwise swap a tampered image back in) and kernel.kexec_load_disabled=1 (blocks kexec).
    protectKernelImage = true;

    # When true, NixOS starts a unit that flips kernel.modules_disabled=1 after boot, so no new kernel modules can be loaded until next reboot. If something tries to modprobe later, it fails. This breaks iptables, opensnitch, etc.
    # TODO consider explicitly preloading any needed modules via boot.kernelModules.
    lockKernelModules = false;

    # Forces KPTI (pti=on) even on CPUs that claim they don’t need it (Meltdown mitigation). Small performance cost, better isolation.
    forcePageTableIsolation = true;

    # Allows user namespaces, which many sandboxes and tools (rootless containers, some browsers, build sandboxes) rely on. (Disabling it will break those.)
    allowUserNamespaces = true;

    # Whether to keep SMT/Hyper-Threading. Disabling can mitigate certain side-channel risks at a noticeable perf cost; for single-user desktops it’s usually left on.
    allowSimultaneousMultithreading = true;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    # Core system tools
    vim
    neovim
    git
    unzip # Required by Mason for extracting packages

    # Web browser (flags are set in chromium module)
    # google-chrome

    # Terminal and shell
    ghostty

    # Wayland/Hyprland essentials
    waybar
    wofi
    wlogout
    pavucontrol # Audio control
    wayvnc # VNC server for Wayland

    # Additional applications
    docker
    zoom-us

    # Development tools
    ollama
    cachix

    # Nix tools
    (pkgs.writeShellScriptBin "devour-flake" ''
      ${pkgs.nix}/bin/nix run github:srid/devour-flake -- "$@"
    '')

    # Clipboard
    wl-clipboard

    # Cursor theme
    apple-cursor

    # Security tools
    firejail
    sbctl # Secure Boot key management
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

  # wayvnc TLS certificate generation service
  systemd.user.services.wayvnc-certs = {
    description = "Generate TLS certificates for wayvnc";
    serviceConfig = {
      Type = "oneshot";
      ExecStart =
        let
          certScript = pkgs.writeShellScript "generate-wayvnc-certs" ''
            CERT_DIR="/home/bryce/.dotfiles/.secrets"
            CERT_FILE="$CERT_DIR/wayvnc-cert.pem"
            KEY_FILE="$CERT_DIR/wayvnc-key.pem"

            # Only generate if certificates don't exist
            if [[ ! -f "$CERT_FILE" || ! -f "$KEY_FILE" ]]; then
              echo "Generating TLS certificates for wayvnc..."
              ${pkgs.openssl}/bin/openssl req -x509 -newkey rsa:4096 \
                -keyout "$KEY_FILE" -out "$CERT_FILE" \
                -days 365 -nodes -batch \
                -subj "/C=US/ST=State/L=City/O=Organization/CN=wayvnc"
              chmod 600 "$KEY_FILE" "$CERT_FILE"
              echo "Certificates generated successfully"
            else
              echo "Certificates already exist, skipping generation"
            fi
          '';
        in
        "${certScript}";
    };
  };

  # wayvnc service configuration
  systemd.user.services.wayvnc = {
    description = "WayVNC server";
    # Removed autostart - use start-vnc script instead
    # wantedBy = [ "graphical-session.target" ];
    # partOf = [ "graphical-session.target" ];
    wants = [ "wayvnc-certs.service" ];
    after = [ "wayvnc-certs.service" ];
    serviceConfig = {
      ExecStart = "${pkgs.wayvnc}/bin/wayvnc --gpu -C /home/bryce/.dotfiles/.secrets/wayvnc-config -o HEADLESS-2";
      Restart = "on-failure";
      RestartSec = "1";
      Environment = [
        "WAYLAND_DISPLAY=wayland-1"
        "XDG_RUNTIME_DIR=/run/user/1000"
      ];
    };
  };

  # Nix configuration
  nix.settings = {
    # Enable flakes
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    # Performance optimizations
    max-jobs = "auto";
    cores = 0;

    # Cachix configuration
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      # Add your cachix cache here if you have one
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      # Add your cachix public key here if you have one
    ];

  };

  # System version
  system.stateVersion = "25.05";
}
