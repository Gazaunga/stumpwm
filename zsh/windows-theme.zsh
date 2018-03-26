# ------------------------------------------------------------------------------
#          FILE:  windows.zsh-theme
#   DESCRIPTION:  oh-my-zsh theme file to emulate Windows cmd
#        AUTHOR:  Julia Vallina (soyjulis@gmail.com)
#       VERSION:  1.0.0
#    SCREENSHOT:  screenshot.gif
# ------------------------------------------------------------------------------

setopt PROMPT_SUBST
PROMPT='C:%{${${${(%):-%~}//\//\\}/\~/\\gazbit}%${#${${(%):-%~}//\//\\}/\~/\\\$HOME}G%}> '
