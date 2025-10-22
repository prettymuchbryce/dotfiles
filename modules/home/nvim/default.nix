{ pkgs, flakeRoot, ... }:
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    defaultEditor = true;
    extraConfig = ''
      " Prepend to 'runtimepath'
      set runtimepath^=~/.dotfiles/modules/home/nvim/nvim

      " Then load your init
      luafile ~/.dotfiles/modules/home/nvim/nvim/init.lua
    '';
  };

  opensnitchRules = [
    {
      name = "Allow mason.nvim → GitHub API";
      process = "${pkgs.curl}/bin/curl";
      cmdLine = "curl.*User-Agent: mason\\.nvim";
      protocol = "tcp";
      port = 443;
      host = "(?i)^([a-zA-Z0-9-]+\\.)?github\\.com$";
    }
    {
      name = "Allow mason.nvim → Mason Registry";
      process = "${pkgs.curl}/bin/curl";
      cmdLine = "curl.*User-Agent: mason\\.nvim";
      protocol = "tcp";
      port = 443;
      host = "^api\\.mason-registry\\.dev$";
    }
    {
      name = "Allow mason.nvim → GitHub Raw Content";
      process = "${pkgs.curl}/bin/curl";
      cmdLine = "curl.*User-Agent: mason\\.nvim";
      protocol = "tcp";
      port = 443;
      host = "(?i)^([a-zA-Z0-9-]+\\.)?githubusercontent\\.com$";
    }
  ];

  home.file.".config/open-router.token".source = "${flakeRoot}/.secrets/open-router.token";
}
