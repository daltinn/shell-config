eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="${HOMEBREW_PREFIX}/opt/openssl/bin:$PATH"

# enable compinit for homebrew formulae
fpath=(/opt/homebrew/share/zsh/site-functions $fpath)

# iterm integration
source ~/.iterm2_shell_integration.zsh
