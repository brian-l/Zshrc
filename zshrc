## Brian's Zshrc ##

## Preferences ##
EDITOR=/usr/bin/vim #change to nano, pico, vi, etc
PAGER=/usr/bin/most #less, more, most
export GREP_OPTIONS="--color=auto" #when grep finds a match, it will be highlighted
PATH="$PATH:/home/$USER/bin" #for executables in /home/$USER/bin

#this might be required for some people
LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
printf "\33]701;$LC_CTYPE\007"

autoload -Uz promptinit
skip_global_compinit=1

autoload -Uz vcs_info
autoload -U zmv

#so colors can be accessed via $fg
autoload colors; colors

end="%f%B%b" #turn off colors when the prompt ends
magenta="%{$fg[magenta]%}" #custom color aliases
red="%{$fg[red]%}"
green="%{$fg[green]%}"
cyan="%{$fg[cyan]%}"
left="$magenta<"
right="$magenta>"
WD="$green%~" #working directory
LOC="%{$cyan%}%n$red@$cyan%m" #user@host

if [ "$USER" = "root" ] #change the username to red if root (this saved my ass a few times)
then
	LOC="%{$red%}%n$red@$cyan%m"
fi

## Prompt ##
## You must have UTF8 encoding to use these characters
#The prompt will look something like
# ┌-<user@host>-<working directory>
# └-<current command
prompt="$red┌─$left$cyan$LOC$right$red─$left$WD$right
$red└─$left%{$reset_color%}"
PS2='%(4_.\.)%3_> %E'

promptinit
setopt histignorealldups sharehistory extendedglob nobeep autolist nocasematch markdirs nomatch correct share_history inc_append_history

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 2000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=2000
SAVEHIST=2000
HISTFILE=~/.zsh_history

#Use modern completion system
autoload -Uz compinit
compinit

#some of the default stuff from clint's prompt
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format $'\033[22;35mCompleting %d\e[0m'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

#aliases
alias ls="ls -h --color=auto" #ls will have colors
alias la="ls -Ah --color=auto" #ls will show hidden files with colors
alias ..="cd ../" #simle directory aliases
alias ...="cd ../.."
alias ....="cd ../../.."
alias addr="curl ifconfig.me/ip" #sometimes its useful to know your ip address
#cool visual for git, courtesy of jordanstephens
alias gitlog='git log --graph --pretty="format:%C(yellow)%h%Cblue%d%Creset %s %C(white) %an %ar%Creset"'

## Keybinds ##
# Might require some configuration.

#keybinds for x terminals
bindkey '^[OH' beginning-of-line
bindkey '^[OF' end-of-line
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

#for tmux
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[OC' forward-word
bindkey '^[OD' backward-word

#for urxvt
bindkey '\eOc' forward-word
bindkey '\eOd' backward-word
bindkey	'^[[7~' beginning-of-line
bindkey '^[[8~' end-of-line

#for both
bindkey '^[[3~' delete-char
bindkey '^[[Z' undo

## Functions ##

function chpwd() #any time $PWD changes, this function is called
{
	ls
}

deploy() #quick deployment of code in a git repository
{
	if [ -d ".git" ]
	then
		echo -n "Enter a message: "
		read message
		git add .
		git commit -m $message
		origin=$(git config --local --get branch.master.remote)
		git push -u $origin master
	else
		echo "Not a git repository."
	fi
}

svc() #easy configuration of scripts in /etc/init.d/
{
	sudo /etc/init.d/"$1" "$2"
}

#fix equals to work with portage
unsetopt equals

