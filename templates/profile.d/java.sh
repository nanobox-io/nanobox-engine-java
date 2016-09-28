# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

if [ ! -s ${HOME}/.m2 ]; then
  ln -sf {{data_dir}}/var/m2 ${HOME}/.m2
fi