#          ___
#    _____/ (_)___ ___
#   / ___/ / / __ `__ \
#  (__  ) / / / / / / /
# /____/_/_/_/ /_/ /_/
#
# AUTHOR: subnixr <subnixr[at]gmx[dot]com>
# LICENSE: https://raw.githubusercontent.com/subnixr/slim/master/LICENSE

#---[COLORS]-------------------------------------------------------------------
mainc="2"
sidec="$((mainc + 8))"

#---[PATH]---------------------------------------------------------------------
export PATH="${HOME}/.local/bin:$PATH"
screenfetch -A 'Windows' -D 'Windows97'
#---[history]------------------------------------------------------------------
export HISTSIZE=1000
export HISTFILE="$HOME/.zsh_history"
export SAVEHIST=1000

setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE

#---[env]----------------------------------------------------------------------
export EDITOR="vi"
export PAGER="less"
export GREP_COLOR="0;3${mainc}"

#---[colored man]--------------------------------------------------------------
export LESS_TERMCAP_mb=$(printf "\e[0;3${mainc}m")    # start blink
export LESS_TERMCAP_md=$(printf "\e[0;3${mainc}m")    # start bold
export LESS_TERMCAP_so=$(printf "\e[7;3${mainc}m")    # start standout
export LESS_TERMCAP_us=$(printf "\e[1;4;3${mainc}m")  # start underline
export LESS_TERMCAP_me=$(printf "\e[0m")              # stop blink, bold
export LESS_TERMCAP_se=$(printf "\e[0m")              # stop standout
export LESS_TERMCAP_ue=$(printf "\e[0m")              # stop underline

#---[autoload]-----------------------------------------------------------------
autoload -U compinit && compinit
autoload -U colors && colors

#---[case insensitive completion]--------------------------------------------
zstyle ':completion:*' menu select=2
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

#---[vimode]-------------------------------------------------------------------
bindkey -v
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^r' history-incremental-search-backward
bindkey -M vicmd '/' history-incremental-search-backward
bindkey -M vicmd 'j' history-beginning-search-forward
bindkey -M vicmd 'k' history-beginning-search-backward
bindkey -M vicmd 'K' run-help

export KEYTIMEOUT=1

#---[aliases]------------------------------------------------------------------
alias ls="ls --color=auto"
alias l="ls -lah"
alias grep="grep --color=auto"

#---[prompt]-------------------------------------------------------------------
setopt PROMPT_SUBST

function slim_path {
    local grey="%{\e[38;5;244m%}"
    local reset="%{\e[0m%}"
    local cwd="%2~"
    cwd="${(%)cwd}" # expand
    echo "$grey${cwd//\//$reset/$grey}$reset %m" # colour
}

function slim_prompt {
    local u_sts="%{\e[%(1j.1.0);3%(0?.$mainc.1)m%}%(!.#.$)%{\e[0m%}"
    local v_sts=">"
    [ "$KEYMAP" = 'vicmd' ] && v_sts="-"
    echo "$u_sts $v_sts"
}

function zle-line-init zle-keymap-select {
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

PROMPT='$(slim_prompt) '
RPROMPT='$(slim_path)'

#---[magic enter]--------------------------------------------------------------

function slim_wrap {
    local txt="$1"
    local ext="${2:-0}"
    local int="${3:-38;5;244}"

    echo "\e[${ext}m[\e[${int}m${txt}\e[${ext}m]"
}

function slim-magic-enter {
    local err="$?"

    [ -n "$BUFFER" ] && {zle accept-line; return}

    local clr_w="\e[0m"
    local clr_g="\e[38;5;244m"
    local raw_r="0;31"
    local raw_rb="1;31"

    # user@host
    local user_host="$clr_g%n$clr_w@$clr_g%m$clr_w"
    local user_host_e="${(%)user_host}"

    # full working dir
    local cwd="$clr_g%~$clr_w"
    local cwd_e="${(%)cwd}"
    local cwd_c="${cwd_e//\//$clr_w/$clr_g}"

    # jobs
    local job_n="$(jobs | sed -n '$=')"

    local iline="$(slim_wrap $user_host_e:$cwd_c)"
    [ "$job_n" -gt 0 ] && iline="$iline $(slim_wrap "$job_n&")"
    [ "$err" != "0" ] && iline="$iline $(slim_wrap "$err" $raw_r $raw_rb)"

    printf "$iline$clr_w\n"

    local output="$(ls -C --color="always" -w $COLUMNS)"
    local output_len="$(echo "$output" | sed -n '$=')"

    if [ -n "$output" ]; then
        if [ "$output_len" -gt "$((LINES - 2))" ]; then
            printf "$output\n" | "$PAGER" -R
        else
            printf "$output\n" | sed "s/^/  | /"
        fi
    fi
    zle redisplay
}

zle -N slim-magic-enter
bindkey -M main  "^M" slim-magic-enter
bindkey -M vicmd "^M" slim-magic-enter

#---[Syntax Highligh]----------------------------------------------------------
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)

ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=red"
ZSH_HIGHLIGHT_STYLES[reserved-word]="fg=$mainc"
ZSH_HIGHLIGHT_STYLES[alias]="fg=$mainc"
ZSH_HIGHLIGHT_STYLES[builtin]="fg=$mainc"
ZSH_HIGHLIGHT_STYLES[function]="fg=$mainc"
ZSH_HIGHLIGHT_STYLES[command]="fg=$mainc"
ZSH_HIGHLIGHT_STYLES[precommand]="underline,fg=$mainc"
ZSH_HIGHLIGHT_STYLES[commandseparator]="fg=blue"
ZSH_HIGHLIGHT_STYLES[hashed-command]="fg=$mainc"
ZSH_HIGHLIGHT_STYLES[globbing]="fg=yellow"
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]="fg=$sidec"
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]="fg=$sidec"
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=yellow"
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=yellow"
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]="fg=blue"
ZSH_HIGHLIGHT_STYLES[redirection]="fg=$sidec"
ZSH_HIGHLIGHT_STYLES[arg0]="fg=$mainc"

# only first time search; distro dependent
zsh_sh="${HOME}/.zsh-sh"
if [ ! -e "$zsh_sh" ]; then
    echo "searching for zsh syntax highlighting plugin. This is done once"
    find /usr -name 'zsh-syntax-highlighting.zsh' 2> /dev/null \
    | head -n 1 > $zsh_sh
fi

zsh_sh_p="$(cat $zsh_sh)"
[ -n "$zsh_sh_p" ] && source $zsh_sh_p

unset zsh_sh zsh_sh_p

source $HOME/zsh/windows-theme.zsh
