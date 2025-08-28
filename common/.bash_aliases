PS1="${debian_chroot:+($debian_chroot)}\[\033[01;92m\]\u\[\033[21;96m\]@\[\033[01;92m\]\h\[\033[37m\]:\[\033[94m\]\w\[\033[0m\] \[\033[3 q\]"

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias la='ls -AF'

alias code='codium'
alias trewq='tree -haLF 1'
alias messenger='/opt/Caprine-2.60.3.AppImage'

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

findinfiles() {
  grep -rnw "$1" -e "$2"
}
__findinfiles() {
  case ${COMP_CWORD} in
    1) COMPREPLY=("<dir>") ;;
    2) COMPREPLY=("<pattern>") ;;
    *) COMPREPLY=() ;;
  esac
}
complete -F __findinfiles findinfiles

ytdlp() {
  ~/.local/bin/yt-dlp --output "%(channel)s - %(title)s.%(ext)s" \
  --extract-audio --audio-format best --audio-quality 0 \
  --embed-thumbnail --convert-thumbnails jpg \
  --ppa "ffmpeg: -c:v mjpeg -vf \"crop='if(gt(ih,iw),iw,ih)':'if(gt(iw,ih),ih,iw)', scale='min(iw,720)':-1\"" \
  --paths ~/Music/yt-dlp "$1"
}
__ytdlp() {
  [[ ${COMP_CWORD} -le 1 ]] && COMPREPLY="<yt url>"
}
complete -F __ytdlp ytdlp

discordUpdate() {
  sudo apt install ~/Downloads/discord-?.?.*.deb -y
  rm ~/Downloads/discord-?.?.*.deb
  discord &
}
