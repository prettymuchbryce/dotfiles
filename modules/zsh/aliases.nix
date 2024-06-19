{
  rl = "source ~/.zshrc";
  nvm = "fnm";
  dotfiles = "vim ~/.dotfiles";
  vimrc = "vim ~/.dotfiles/modules/nvim/nvim";
  etchosts = "sudo vim /etc/hosts";
  prj = "cd ~/projects";
  nixrb = "darwin-rebuild switch --flake ~/.dotfiles --verbose";
  tf = "terraform";
  notes = "cd ~/notes && vim ~/notes/README.md -c \":NvimTreeOpen\"";
  staked = "bash ~/scripts/query-staked.sh";

  open-webui = "docker run -d -p 6671:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main";

  # open current directory in github
  ghw = "gh repo view --web";

  # tmux
  tkill = "tmux kill-server";
  tstart = "tmux start-server";
  mux = "tmuxinator";

  # trendies
  taws = "AWS_PROFILE=trendies aws";

  focus = "sudo cp -rf ~/.config/hosts/hosts.focus /etc/hosts";
  unfocus = "sudo cp -rf ~/.config/hosts/hosts.unfocus /etc/hosts";

  # Navigation;
  ".." = "cd ..";
  "..." = "cd ../..";
  "...." = "cd ../../..";
  "....." = "cd ../../../..";

  # Grep;
  grep = "grep --color=auto";
}
