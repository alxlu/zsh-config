# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# [[ ! -f $HOME/.ssh/id_rsa ]] || eval `keychain --quick --quiet --eval --agents ssh id_rsa`

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

zinit ice depth=1; zinit light romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[[ ! -f "${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}/.p10k.zsh" ]] || source "${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}/.p10k.zsh"

# lower keytimeout for addtional characters in sequence (helpful for vim mode)
export KEYTIMEOUT=1

# History
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST

[[ ! -f $XDG_CONFIG_HOME/aliases ]] || source $XDG_CONFIG_HOME/aliases

zinit ice wait'0a' lucid
zinit light zsh-users/zsh-autosuggestions
export ZSH_AUTOSUGGEST_USE_ASYNC="true"
export ZSH_AUTOSUGGEST_COMPLETION_IGNORE="z *"

zinit ice wait'0b' lucid
zinit light zdharma-continuum/fast-syntax-highlighting

zinit ice wait'0d' lucid
zinit light wookayin/fzf-fasd

zinit ice wait'0e' lucid
zinit light changyuheng/zsh-interactive-cd

zplugin light romkatv/zsh-defer

bindkey -v
autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd e edit-command-line

# change cursor to indicate vim mode
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'

  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init

# Use beam shape cursor on startup.
echo -ne '\e[5 q'
# Use beam shape cursor for each new prompt.
preexec() { echo -ne '\e[5 q' ;}

load_lfcd() {
  TERMINFO=
  LFCD="$HOME/.config/lf/lfcd.sh"
  if [ -f "$LFCD" ]; then
    source "$LFCD"
    bindkey -s '^o' 'lfcd\n'
  fi
}

zsh-defer load_lfcd
bindkey -s '^p' 'launch\n'

load_fasd() {
  eval "$(fasd --init auto)"
}

zsh-defer load_fasd

  export NVM_DIR="$HOME/.config/nvm"
load_nvm() {
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
}
zsh-defer load_nvm

# Basic auto/tab complete:
load_tab_completion() {
  autoload -U compinit
  zstyle ':completion:*' menu select
  zmodload zsh/complist
  compinit
  _comp_options+=(globdots)		# Include hidden files.
}

zsh-defer load_tab_completion

# TODO: find a better way to do this check...
source_fzf() {
  # macOS
  [[ ! -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]] || source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
  [[ ! -f /opt/homebrew/opt/fzf/shell/completion.zsh ]] || source /opt/homebrew/opt/fzf/shell/completion.zsh
  # Arch
  [[ ! -f /usr/share/fzf/key-bindings.zsh ]] || source /usr/share/fzf/key-bindings.zsh
  [[ ! -f /usr/share/fzf/completion.zsh ]] || source /usr/share/fzf/completion.zsh

  # Fedora
  [[ ! -f /usr/share/fzf/shell/key-bindings.zsh ]] || source /usr/share/fzf/shell/key-bindings.zsh
  [[ ! -f /usr/share/zsh/site-functions/fzf ]] || source /usr/share/zsh/site-functions/fzf

  # Ubuntu
  [[ ! -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] || source /usr/share/doc/fzf/examples/key-bindings.zsh
  [[ ! -f /usr/share/zsh/vendor-completions/_fzf ]] || source /usr/share/zsh/vendor-completions/_fzf
}
zsh-defer source_fzf
