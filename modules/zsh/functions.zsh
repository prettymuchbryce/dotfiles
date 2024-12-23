# Install warpdrive
wd() {
  . ~/zsh/plugins/wd/wd.sh
}

# Function to update tab name before a command is executed
zellij_tab_name_preexec() {
  if [[ -n $ZELLIJ ]]; then
    local cmd_name=${1%% *}  # Extract the command name
    command nohup zellij action rename-tab "$cmd_name" >/dev/null 2>&1
  fi
}

# Function to update tab name after a command finishes or when directory changes
zellij_tab_name_precmd() {
  if [[ -n $ZELLIJ ]]; then
    local tab_name
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      tab_name+=$(basename "$(git rev-parse --show-toplevel)")/
      tab_name+=$(git rev-parse --show-prefix)
      tab_name=${tab_name%/}
    else
      tab_name=$PWD
      if [[ $tab_name == $HOME ]]; then
        tab_name="~"
      else
        tab_name=${tab_name##*/}
      fi
    fi
    command nohup zellij action rename-tab "$tab_name" >/dev/null 2>&1
  fi
}

# Add functions to Zsh hooks
preexec_functions+=(zellij_tab_name_preexec)
precmd_functions+=(zellij_tab_name_precmd)
chpwd_functions+=(zellij_tab_name_precmd)
