PS1="${debian_chroot:+($debian_chroot)}\[\033[01;92m\]\u\[\033[22;96m\]@\[\033[01;92m\]\h\[\033[37m\]:\[\033[94m\]\w\[\033[0m\] \[\033[3 q\]"

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias la='ls -AF'

alias code='codium'
alias trewq='tree -haLF 1'
alias discord='vesktop'

clean() {
  clear
  echo "Here, cleaned the screen for you dumass."
}
CLEAR() {
  clear
  echo "CAPS LOCK DUMASS."
}
cleaar() {
  clear
  echo "Here, \"cleaared\" the screen for you fatfingers."
}
claer() {
  clear
  echo "Here, claered the screen for you fatfingers."
}
clea() {
  clear
  echo "Here, clea'd the screen for you fatfingers."
}
cler() {
  clear
  echo "Here, cler'd the screen for youu fatfingers."
}
clea() {
  clear
  echo "Here, clea'd the screen for you fatfingers."
}
cear() {
  clear
  echo "Here, cear'd the screen for you fatfingers."
}

findInFiles() {
  grep -rnw "$1" -e "$2"
}
__findInFiles() {
  case ${COMP_CWORD} in
    1) COMPREPLY=("<dir>") ;;
    2) COMPREPLY=("<pattern>") ;;
    *) COMPREPLY=() ;;
  esac
}
complete -F __findInFiles findInFiles

ytdlp() {
  case "$2" in
    left)  from=":0:0" ;;
    right) from=":'iw-min(iw,720)':'ih-min(iw,720)'" ;;
    *)     from="" ;;
  esac

  yt-dlp --output "%(channel)s - %(title)s.%(ext)s" \
  --extract-audio --audio-format best --audio-quality 0 \
  --embed-thumbnail --convert-thumbnails jpg \
  --ppa "ffmpeg: -c:v mjpeg -vf \"crop='if(gt(ih,iw),iw,ih)':'if(gt(iw,ih),ih,iw)'$from, scale='min(iw,720)':-1\"" \
  --paths ~/Music/yt-dlp "$1"
}
__ytdlp() {
  [[ ${COMP_CWORD} -eq 1 ]] && COMPREPLY="<yt url>"
  [[ ${COMP_CWORD} -eq 2 ]] && COMPREPLY="<left/right/* (default center)>"
}
complete -F __ytdlp ytdlp

# find [things] -print0 | xargs -0 [do stuff] is really powerful!
cpFilesOfTypeWithinDirectory() {
  if [ $# -eq 0 ]; then
    echo "No arguments! Nothing done."
  else
    [ -z "$2" ] && set -- "$1" "extracted_$1"
    mkdir -p "$2"
    find -name "*.$1" -print0 | xargs -0 cp --parents -t "$2"
  fi
}
__cpFilesOfTypeWithinDirectory() {
  case ${COMP_CWORD} in
    1) COMPREPLY=("file.<ext>") ;;
    2) COMPREPLY=("<destination>") ;;
    *) COMPREPLY=() ;;
  esac
}

rmFilesOfTypeWithinDirectory() {
  if [ $# -eq 0 ]; then
    echo "No arguments! Nothing done."
  else
    find -name "*.$1" -print0 | xargs -0 rm
  fi
}
__rmFilesOfTypeWithinDirectory() {
  [[ ${COMP_CWORD} -eq 1 ]] && COMPREPLY="file.<ext>"
}

complete -F __cpFilesOfTypeWithinDirectory cpFilesOfTypeWithinDirectory
complete -F __rmFilesOfTypeWithinDirectory rmFilesOfTypeWithinDirectory
