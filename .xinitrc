# Make sure this is before the 'exec' command or it won't be sourced.
[ -f /etc/xprofile ] && . /etc/xprofile
[ -f ~/.xprofile ] && . ~/.xprofile
exec stumpwm
dunst -fn "$DUNST_FONT" -geometry "$DUNST_SIZE" &
#emacsclient -c
#emacs -fs
