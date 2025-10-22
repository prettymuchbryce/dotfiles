{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Force the root filesystem to tmpfs (ephemeral)
  fileSystems."/" = lib.mkForce {
    device = "none";
    fsType = "tmpfs";
    # Use a percentage of RAM so you don't hard-cap yourself.
    options = [
      "defaults"
      "size=25%"
      "mode=755"
    ];
  };

  # Mount the ext4 filesystem
  # Using the ext4 UUID ensures we mount the FS inside the LUKS mapping.
  fileSystems."/persist" = lib.mkForce {
    device = "/dev/disk/by-uuid/f9a74e48-d897-4e1e-af91-22299fb251c4";
    fsType = "ext4";
    options = [ "x-initrd.mount" ];
    neededForBoot = true;
  };

  # /nix as a bind (stage-2)
  # This ends up showing a ext4 subdir mount from the LUKS device because
  # stage-1 mounts /nix early and stage-2 adopts it. Functionally it's the same
  # just sort of annoying and weird.
  fileSystems."/nix" = lib.mkForce {
    device = "/persist/nix";
    fsType = "none";
    options = [ "bind" ];
    neededForBoot = true;
    depends = [ "/persist" ];
  };

  # Helpful on laptops/desktops to cushion tmpfs pressure:
  zramSwap.enable = true;
}
