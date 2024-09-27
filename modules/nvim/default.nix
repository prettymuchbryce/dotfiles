{ pkgs, ... }:
{
  xdg.configFile.nvim = {
    source = ./nvim;
    recursive = true;
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    defaultEditor = true;
    extraConfig = ":luafile ~/.config/nvim/init.lua;";
  };

  home.file.".config/open-router.token".source = ../../.secrets/open-router.token;
}
