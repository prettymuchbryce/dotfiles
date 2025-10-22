{
  # Cross-platform aliases
  rl = "source ~/.zshrc";
  dotfiles = "vim ~/.dotfiles";
  vimrc = "vim ~/.dotfiles/modules/home/nvim/nvim";
  tf = "terraform";
  notes = "cd ~/notes && vim ~/notes/README.md -c \":NvimTreeOpen\"";

  # Platform-aware rebuild commands
  # macOS: darwin-rebuild, NixOS: nixos-rebuild
  nixrb = "if [[ \"$(uname)\" == \"Darwin\" ]]; then sudo darwin-rebuild switch --flake ~/.dotfiles --verbose; else sudo nixos-rebuild switch --flake ~/.dotfiles\\#meerkat --verbose; fi";

  # Docker and development
  open-webui = "docker run -d -p 6671:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main";

  # Git shortcuts
  ghw = "gh repo view --web";

  # Navigation shortcuts
  ".." = "cd ..";
  "..." = "cd ../..";
  "...." = "cd ../../..";
  "....." = "cd ../../../..";

  # Enhanced grep
  grep = "grep --color=auto";

  # VNC control (Linux only)
  start-vnc = "~/.dotfiles/scripts/start-vnc";
  stop-vnc = "~/.dotfiles/scripts/stop-vnc";
}
