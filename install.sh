#!/usr/bin/env zsh

#git clone https://github.com/daltinn/shell-config.git
#cd shell-config

source assets/install_lib.zsh

git submodule update --init --recursive

# Absolute path to this script. /home/user/bin/foo.sh
SCRIPT=$(readlink -f $0)
# Absolute path this script is in. /home/user/bin
SHELL_CONFIG_PATH_BASE=`dirname $SCRIPT`

echo "type path to "CUSTOM" folder (not possible to use '\$HOME' or '\~' var):"
read SHELL_CONFIG_PATH_CUSTOM

cat <<EOT > zshrc.local
# Don't edit this file, content may-be overwriten
SHELL_CONFIG_PATH_CUSTOM=$SHELL_CONFIG_PATH_CUSTOM
SHELL_CONFIG_PATH_BASE=$SHELL_CONFIG_PATH_BASE
EOT

# Create config hierarchy in $SHELL_CONFIG_PATH_CUSTOM
if [[ ! -d $SHELL_CONFIG_PATH_CUSTOM && ! -z $SHELL_CONFIG_PATH_CUSTOM ]]; then
  mkdir -p $SHELL_CONFIG_PATH_CUSTOM
  cp -rn assets/shell-config-custom-template/*  $SHELL_CONFIG_PATH_CUSTOM/
fi

typeset -a config_files
config_files=(tmux.conf
  tmux.conf.local
  p10k.zsh
  zshrc
  zshrc.local
  zprofile
  profile
)

bkp_date=`date -Iseconds`

cd ~
for ((i = 1; i <= $#config_files; i++)) create_link $config_files[i]
