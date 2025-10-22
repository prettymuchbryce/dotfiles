{
  config,
  pkgs,
  lib,
  ...
}:
let
  # Collect persistence rules from all home-manager users (like OpenSnitch pattern)
  hmUsers = config.home-manager.users or { };
  
  # Extract user persistence rules from home-manager modules
  # Each user can have persistenceDirectories and persistenceFiles
  hmUserPersistence = lib.mapAttrs (username: userConfig: {
    directories = userConfig.persistenceDirectories or [ ];
    files = userConfig.persistenceFiles or [ ];
  }) hmUsers;

  # Collect system-level persistence from modules that define persistenceSystem
  systemPersistence = {
    directories = config.persistenceSystem.directories or [ ];
    files = config.persistenceSystem.files or [ ];
  };

  # Collect system-specified user persistence from modules that define persistenceUsers
  systemUserPersistence = config.persistenceUsers or { };

  # Merge system-specified user persistence with home-manager user persistence
  mergedUserPersistence = lib.mapAttrs (username: hmConfig: {
    directories = hmConfig.directories ++ (systemUserPersistence.${username}.directories or [ ]);
    files = hmConfig.files ++ (systemUserPersistence.${username}.files or [ ]);
  }) hmUserPersistence;

in
{
  # Define options for system modules to specify persistence
  options = {
    persistenceSystem = lib.mkOption {
      type = lib.types.submodule {
        options = {
          directories = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "System directories to persist";
          };
          files = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "System files to persist";
          };
        };
      };
      default = { };
      description = "System-level persistence configuration";
    };

    persistenceUsers = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          directories = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "User directories to persist (relative to home)";
          };
          files = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "User files to persist (relative to home)";
          };
        };
      });
      default = { };
      description = "Per-user persistence configuration for system modules";
    };
  };

  config = {
    # Export the collected persistence rules for use by the main persistence module
    _module.args.collectedPersistence = {
      system = systemPersistence;
      users = mergedUserPersistence;
    };
  };
}