{
  rl = "source ~/.zshrc";
  dotfiles = "vim ~/.dotfiles";
  vimrc ="vim ~/.dotfiles/modules/nvim/nvim";
  etchosts = "sudo vim /etc/hosts";
  prj = "cd ~/projects";
  nixrb = "darwin-rebuild switch --flake ~/.dotfiles --verbose";
  tf = "terraform";
  notes = "cd ~/notes && vim ~/notes/README.md -c \":NvimTreeOpen\"";

  # alias ls='exa --icons -F -H --group-directories-first --git -1'
  # alias staked='bash ~/scripts/query-staked.sh'
  # alias play="sudo cp -rf /etc/hosts.bryce.play /etc/hosts"
  # alias work="sudo cp -rf /etc/hosts.bryce.work /etc/hosts"
  # alias focus="sudo cp -rf /etc/hosts.bryce.focus /etc/hosts"

  # Navigation;
  ".." = "cd ..";
  "..." = "cd ../..";
  "...." = "cd ../../..";
  "....." = "cd ../../../..";

  # Grep;
  grep = "grep --color=auto";
}
