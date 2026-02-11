# pmset.nix - macOS power management settings via pmset
# Adapted from https://github.com/wwmoraes/dotfiles/blob/master/modules/nix-darwin/system/pmset.nix
{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    ;
  cfg = config.system;
  commonOptions = {
    displaysleep = mkOption {
      type = with types; nullOr ints.unsigned;
      default = null;
      description = "display sleep timer in minutes (0 to disable)";
    };
    disksleep = mkOption {
      type = with types; nullOr ints.unsigned;
      default = null;
      description = "disk spindown timer in minutes (0 to disable)";
    };
    sleep = mkOption {
      type = with types; nullOr ints.unsigned;
      default = null;
      description = "system sleep timer in minutes (0 to disable)";
    };
    womp = mkOption {
      type =
        with types;
        nullOr (enum [
          0
          1
        ]);
      default = null;
      description = "wake on ethernet magic packet. Same as 'Wake for network access' in System Settings.";
    };
    ring = mkOption {
      type =
        with types;
        nullOr (enum [
          0
          1
        ]);
      default = null;
      description = "wake on modem ring";
    };
    powernap = mkOption {
      type =
        with types;
        nullOr (enum [
          0
          1
        ]);
      default = null;
      description = "enable/disable Power Nap on supported machines";
    };
    proximitywake = mkOption {
      type =
        with types;
        nullOr (enum [
          0
          1
        ]);
      default = null;
      description = "On supported systems, this option controls system wake from sleep based on proximity of devices using same iCloud id.";
    };
    autorestart = mkOption {
      type =
        with types;
        nullOr (enum [
          0
          1
        ]);
      default = null;
      description = "automatic restart on power loss";
    };
    lidwake = mkOption {
      type =
        with types;
        nullOr (enum [
          0
          1
        ]);
      default = null;
      description = "wake the machine when the laptop lid (or clamshell) is opened";
    };
    acwake = mkOption {
      type =
        with types;
        nullOr (enum [
          0
          1
        ]);
      default = null;
      description = "wake the machine when power source (AC/battery) is changed";
    };
    lessbright = mkOption {
      type =
        with types;
        nullOr (enum [
          0
          1
        ]);
      default = null;
      description = "slightly turn down display brightness when switching to this power source";
    };
    halfdim = mkOption {
      type =
        with types;
        nullOr (enum [
          0
          1
        ]);
      default = null;
      description = "display sleep will use an intermediate half-brightness state between full brightness and fully off";
    };
    sms = mkOption {
      type =
        with types;
        nullOr (enum [
          0
          1
        ]);
      default = null;
      description = "use Sudden Motion Sensor to park disk heads on sudden changes in G force";
    };
    hibernatemode = mkOption {
      type =
        with types;
        nullOr (enum [
          0
          3
          25
        ]);
      default = null;
      description = ''
        change hibernation mode. Please use caution.

        hibernatemode = 0 by default on desktops. The system will not back
        memory up to persistent storage.

        hibernatemode = 3 by default on portables. The system will store a copy
        of memory to persistent storage (the disk), and will power memory during
        sleep.

        hibernatemode = 25 is only settable via pmset. The system will store a
        copy of memory to persistent storage (the disk), and will remove power
        to memory.
      '';
    };
    hibernatefile = mkOption {
      type = with types; nullOr path;
      default = null;
      example = /var/vm/sleepimage;
      description = "change hibernation image file location. Image may only be located on the root volume.";
    };
    ttyskeepawake = mkOption {
      type =
        with types;
        nullOr (enum [
          0
          1
        ]);
      default = null;
      description = "prevent idle system sleep when any tty (e.g. remote login session) is 'active'.";
    };
    networkoversleep = mkOption {
      type = with types; nullOr int;
      default = null;
      description = "this setting affects how OS X networking presents shared network services during system sleep.";
    };
    destroyfvkeyonstandby = mkOption {
      type =
        with types;
        nullOr (enum [
          0
          1
        ]);
      default = null;
      description = "Destroy File Vault Key when going to standby mode. (1 = Destroy, 0 = Retain)";
    };
    standbydelay = mkOption {
      type = with types; nullOr ints.unsigned;
      default = null;
      description = "delay, in seconds, before writing the hibernation image to disk and powering off memory for Standby.";
    };
    standbydelayhigh = mkOption {
      type = with types; nullOr ints.unsigned;
      default = null;
      description = "delay, in seconds, before writing the hibernation image to disk. Used when battery is below highstandbythreshold.";
    };
    standbydelaylow = mkOption {
      type = with types; nullOr ints.unsigned;
      default = null;
      description = "delay, in seconds, before writing the hibernation image to disk. Used when battery is above highstandbythreshold.";
    };
    highstandbythreshold = mkOption {
      type = with types; nullOr (ints.between 0 100);
      default = null;
      example = 50;
      description = "battery capacity threshold that defines which delay a standby machine will use before hibernating.";
    };
    autopoweroffdelay = mkOption {
      type = with types; nullOr ints.unsigned;
      default = null;
      example = 50;
      description = "delay, in seconds, before entering autopoweroff mode.";
    };
  };
  writePmset =
    flag: entries:
    lib.strings.optionalString (
      (builtins.length entries) > 0
    ) "pmset ${flag} ${lib.concatStringsSep " " entries}";
  pmsetSettingsToList =
    attrs:
    lib.mapAttrsToList (k: v: "${k} ${builtins.toString v}") (lib.filterAttrs (n: v: v != null) attrs);
  pmset = flag: attrs: writePmset flag (pmsetSettingsToList attrs);
in
{
  options = {
    system.pmset.all = mkOption {
      type =
        with types;
        nullOr (submodule {
          options = commonOptions;
        });
      default = { };
      description = "Power management settings that apply to all energy sources.";
    };
    system.pmset.battery = mkOption {
      type =
        with types;
        nullOr (submodule {
          options = commonOptions;
        });
      default = { };
      description = "Power management settings that apply while on battery power.";
    };
    system.pmset.charger = mkOption {
      type =
        with types;
        nullOr (submodule {
          options = commonOptions;
        });
      default = { };
      description = "Power management settings that apply while on wall power.";
    };
    system.pmset.ups = mkOption {
      type =
        with types;
        nullOr (submodule {
          options = commonOptions // {
            haltlevel = mkOption {
              type = with types; nullOr (ints.between (-1) 100);
              default = null;
              description = "when draining UPS battery, battery level at which to trigger an emergency shutdown (value in %)";
            };
            haltafter = mkOption {
              type = with types; nullOr (oneOf [ (enum [ (-1) ]) ints.unsigned ]);
              default = null;
              description = "when draining UPS battery, trigger emergency shutdown after this long running on UPS power (value in minutes, or 0 to disable)";
            };
            haltremain = mkOption {
              type = with types; nullOr (oneOf [ (enum [ (-1) ]) ints.unsigned ]);
              default = null;
              description = "when draining UPS battery, trigger emergency shutdown when this much time remaining on UPS power is estimated (value in minutes, or 0 to disable)";
            };
          };
        });
      default = { };
      description = "Power management settings that apply while on UPS power.";
    };
  };

  config = {
    system.activationScripts.extraActivation.text = lib.mkAfter ''
      echo >&2 "configuring power management..."
      ${pmset "-a" cfg.pmset.all}
      ${pmset "-b" cfg.pmset.battery}
      ${pmset "-c" cfg.pmset.charger}
      ${pmset "-u" cfg.pmset.ups}
    '';
  };
}
