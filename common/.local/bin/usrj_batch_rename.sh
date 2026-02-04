#!/bin/sh

if [ "$1" = -h ] || [ "$1" = --help ]; then
  echo "Usage: usrj_batch_rename.sh [selection glob] [before pattern] [after pattern]"
  echo " ! Beware: all found pattern are replaced, not only the first occurence !"
  exit
fi

if [ $# -lt 3 ]; then
  echo "Not enough arguments. Aborting."
  exit
fi


for f in "$1"; do
  fmod="$(echo $f | sed -e 's/'"$2"'/'"$3"'/g')"

  if [ "$f" != "$fmod" ]; then
    f_msg="$(echo $f | sed -e 's/'"$2"'/[32m'"$2"'[0m/g')"
    fmod_msg="$(echo $fmod | sed -e 's/'"$3"'/[32m'"$3"'[0m/g')"
    echo "$f_msg  [31m->[0m  $fmod_msg"

    mv "$f" "$fmod"
  fi
done

# FIXME
# here, that worked before: for f in *.opus;do mv "$f" "$(echo $f | sed -e 's/ .opus/.opus/g')";done
