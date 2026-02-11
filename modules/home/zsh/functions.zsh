# Zellij tab naming via tabname script + zellij-tab-name plugin.

__zellij_cmd_running=""

zellij_tab_name_preexec() {
  if [[ -n $ZELLIJ ]]; then
    __zellij_cmd_running="${1%% *}"
    tabname "$__zellij_cmd_running" &!
  fi
}

zellij_tab_name_precmd() {
  if [[ -n $ZELLIJ ]]; then
    __zellij_cmd_running=""
    tabname "zsh" &!
  fi
}

zellij_tab_name_chpwd() {
  if [[ -n $ZELLIJ ]]; then
    tabname "${__zellij_cmd_running:-zsh}" &!
  fi
}

preexec_functions+=(zellij_tab_name_preexec)
precmd_functions+=(zellij_tab_name_precmd)
chpwd_functions+=(zellij_tab_name_chpwd)
