-[X] Neovim Issues.
-[X] How to customize mouse speed in Hyprland?
-[X] Display time in waybar.
-[X] Remove all old Gnome code.
-[X] Copy paste still doesnt work.
-[ ] Security audit.
-[ ] Figure out little snitch alternative.
-[ ] Figure out sync thing.
-[ ] Figure out password manager solution.


Security:
   - AppAmor
   - Firewall (ufw)
   - Disable root login?
   - Disabling unnecessary services (systemctl)
   - Disable all brave tracking
   - OpenSnitch.
   - Enable audit logging via auditd
      kernel.dmesg_restrict = 1 - Prevents unprivileged users from reading kernel messages (dmesg). Kernel messages can leak sensitive information about hardware, memory addresses, or system internals that attackers could use.
      kernel.kptr_restrict = 2 - Hides kernel memory addresses from all users (even root). Memory addresses help attackers exploit kernel vulnerabilities by knowing where to target their attacks.
      net.ipv4.conf.all.send_redirects = 0 - Prevents your system from sending ICMP redirect messages, which can be abused to redirect traffic through malicious routes.
      net.ipv4.conf.default.send_redirects = 0 - Same as above but for new interfaces.
