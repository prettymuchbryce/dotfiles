{
  config,
  pkgs,
  lib,
  flakeRoot,
  hostname,
  ...
}:

let
  isMacBookPro = hostname == "Bryces-MacBook-Pro";
  isMacMini = hostname == "Bryces-Mac-mini";
  isDarwinSyncthing = pkgs.stdenv.isDarwin && (isMacBookPro || isMacMini);

  readSecret =
    name: lib.strings.removeSuffix "\n" (builtins.readFile "${flakeRoot}/.secrets/${name}");

  machineKey = if isMacBookPro then "macbook-pro" else "mac-mini";

  secretsDir = "${config.home.homeDirectory}/.dotfiles/.secrets";
in
lib.mkIf isDarwinSyncthing {
  services.syncthing = {
    enable = true;

    # Use pre-generated keys for deterministic device ID
    cert = "${secretsDir}/syncthing-${machineKey}-cert.pem";
    key = "${secretsDir}/syncthing-${machineKey}-key.pem";

    overrideDevices = true;
    overrideFolders = true;

    settings = {
      devices = {
        "Bryces-MacBook-Pro" = {
          id = readSecret "syncthing-macbook-pro-device-id";
          addresses = [ "dynamic" ];
        };
        "Bryces-Mac-mini" = {
          id = readSecret "syncthing-mac-mini-device-id";
          addresses = [ "dynamic" ];
        };
      };

      folders = {
        "notes" = {
          id = "notes";
          path = "~/notes";
          devices = [
            "Bryces-MacBook-Pro"
            "Bryces-Mac-mini"
          ];
        };
      };

      options = {
        globalAnnounceEnabled = false;
        localAnnounceEnabled = true;
        relaysEnabled = false;
        natEnabled = false;
        urAccepted = -1;
      };
    };
  };
}
