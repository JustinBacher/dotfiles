# file and directory manipulation
abbr rm rm -iv
abbr cp cp -iv
abbr mv mv -iv
abbr ln ln -iv
abbr mkdir mkdir -pv

# file explorer
abbr e yazi

# using custom implementations of base linux commands
abbr ls eza -lag --header
abbr lt eza --tree --level=2
abbr stow xstow
abbr df duf
abbr dft dutree
abbr dfs dutree -s

# Safetynets [Parenting changing perms on / #]
abbr chown chown -v --preserve-root
abbr chmod chmod -v --preserve-root
abbr chgrp chgrp --preserve-root
abbr chmox chmod +x --preserve-root


# shortening common commands
abbr h history
abbr cls clear
abbr c clear
abbr which type -a
abbr sd shutdown now
abbr rb reboot

# application shorthands
abbr v nvim
abbr v. nvim .
abbr vi nvim
abbr vim nvim
abbr neofetch fastfetch
abbr ani ani-cli

# package manager shortcuts
abbr yay paru
abbr yays paru -S --skipreview
abbr yayr paru -Rns
abbr yayup paru && ~/.tmux/plugins/tpm/scripts/update_plugin.sh "all"

# git
abbr g git
abbr gti git
abbr ga git add
abbr gc git commit -m
abbr gs git status
abbr gco git checkout
abbr gl git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
abbr gaa git add .
abbr gg lazygit

# pinging / ports
abbr ping ping -c 5
abbr pingg ping google.com -c 5
abbr ports netstat -tulanp

# ease of use / fun
abbr :q exit
abbr q exit
abbr qq exit
abbr bye exit
abbr ffs fuck
abbr fucking sudo
abbr please sudo !!
abbr dammit fuck

abbr py python3
