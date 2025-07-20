{
  # Cross-platform aliases
  rl = "source ~/.zshrc";
  nvm = "fnm";
  dotfiles = "vim ~/.dotfiles";
  vimrc = "vim ~/.dotfiles/modules/nvim/nvim";
  etchosts = "sudo vim /etc/hosts";
  prj = "cd ~/projects";
  nixfupdate = "nix flake update";
  tf = "terraform";
  notes = "cd ~/notes && vim ~/notes/README.md -c \":NvimTreeOpen\"";
  staked = "bash ~/scripts/query-staked.sh";

  # Platform-aware rebuild commands
  # macOS: darwin-rebuild, NixOS: nixos-rebuild
  nixrb = "if [[ \"$(uname)\" == \"Darwin\" ]]; then darwin-rebuild switch --flake ~/.dotfiles --verbose; else sudo nixos-rebuild switch --flake ~/.dotfiles#meerkat --verbose; fi";

  # Docker and development
  open-webui = "docker run -d -p 6671:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main";

  # Git shortcuts
  ghw = "gh repo view --web";

  # macOS-specific tmux aliases (only used on macOS now)
  tkill = "tmux kill-server";
  tstart = "tmux start-server";
  mux = "tmuxinator";

  # Project-specific
  taws = "AWS_PROFILE=trendies aws";
  claudeeng = "(cd ~/projects/claude-engineer && poetry run python main.py)";

  # Focus/productivity (cross-platform)
  focus = "sudo cp -rf ~/.config/hosts/hosts.focus /etc/hosts";
  unfocus = "sudo cp -rf ~/.config/hosts/hosts.unfocus /etc/hosts";

  # Navigation shortcuts
  ".." = "cd ..";
  "..." = "cd ../..";
  "...." = "cd ../../..";
  "....." = "cd ../../../..";

  # Enhanced grep
  grep = "grep --color=auto";
}
