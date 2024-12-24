{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    defaultEditor = true;
    extraConfig = ''
      " Prepend to 'runtimepath'
      set runtimepath^=~/.dotfiles/modules/nvim/nvim

      " Then load your init
      luafile ~/.dotfiles/modules/nvim/nvim/init.lua
    '';
  };

  home.file.".config/open-router.token".source = ../../.secrets/open-router.token;
}
