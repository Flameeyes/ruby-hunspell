#!/bin/sh

package=ruby-hunspell

if [[ $# -ge 1 ]]; then
  version=$1
else
  version=$(date +"%Y-%m-%d_%H-%M")
fi

rm -rf "${package}-${version}"
mkdir "${package}-${version}"
git-ls-files | xargs tar cf - | tar xf - -C "${package}-${version}"

cg-log -f > "${package}-${version}"/ChangeLog

tar -jcf "${package}-${version}.tar.bz2" "${package}-${version}"
