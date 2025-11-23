# UNUSED, COPY-PASTED DIRECTLY AS A HELLISH ONE-LINER

NIRI_CONFIG=$XDG_CONFIG_HOME/niri/config.kdl

grep -e '// off // (gets toggled' $NIRI_CONFIG && \
  sed -i 's/\/\/ off \/\/ (gets toggled by script, dont erase)/off \/\/ (gets toggled by script, dont erase)/' $NIRI_CONFIG || \
  sed -i 's/off \/\/ (gets toggled by script, dont erase)/\/\/ off \/\/ (gets toggled by script, dont erase)/' $NIRI_CONFIG

# There HAS to be a cleaner way with sed/awk/perl/regex/bash substitution, but i can't bother to invest more time on this.
