
create_link() {
  #TODO create backup
  file=$1
  if [[ ! -L .${file} && -f .${file} ]] ; then
    mv .${file} .${file}-${bkp_date}
  fi
  ln -sf $SHELL_CONFIG_PATH_BASE/$file ./.$file
}
