#!/usr/bin/bash

function bak_save() {
  cp -R "$1" "$1.bak"
}

function bak_restore() {
  # check for backup with same name
  find "$1.bak" -depth -maxdepth 0 > /dev/null && find "$1" -depth -maxdepth 0 > /dev/null && rm -rI "$1" && mv "$1.bak" "$1"
}

function bak() {
  if [[ "[\-]{1,2}[a-zA-Z\-]+"=~"$1" ]]; then
    case "$1" in
      save)
        shift
        bak_save "$1"
      ;;
      restore)
        shift
        bak_restore "$1"
      ;;
      help)
        echo "bak: file/folder backup utility."
        echo "USAGE: bak [save|restore] PATH"
        echo "save: Will clone a file or folder (recursively) appending the suffix \".bak\". The copy is saved inside the current working directory. Backup is ALWAYS RECURSIVE."
        echo "restore: will check for a backup corresponding to the given path in the working directory. If it finds one, it will delete the directory at the given path, and replace it with the backup."
        exit 0
      ;;
      *)
        echo "unrecognized command: $1"
        exit 1
      ;;
    esac
  else
    echo "bak: file/folder backup utility."
    echo "USAGE: bak [save|restore] PATH"
    echo "save: Will clone a file or folder (recursively) appending the suffix \".bak\". The copy is saved inside the current working directory. Backup is ALWAYS RECURSIVE."
    echo "restore: will check for a backup corresponding to the given path in the working directory. If it finds one, it will delete the directory at the given path, and replace it with the backup."
    exit 2
  fi
}

bak $@
