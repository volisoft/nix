{ lib }:

with lib.hm.dag; {
  symlink = src: dst:
    entryAfter [ "installPackages" ] ''
      dir="$(dirname ${dst})"
      if [ ! -d "$dir" ]; then
      mkdir -p "$dir"
      fi
      if [ ! -L ${dst} ]; then
      ln -s ${src} ${dst}
      fi
    '';
}
