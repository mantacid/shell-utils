## pdfmerge: append pdfs to other pdfs.
## DEPENDENCIES:
## - bash
## - ghostscript (gs)
function pdfmerge() {
  $SHELL_UTIL_DIR/scripts/pdfmerge.sh "$@"
} #DESC= concatenate pdfs together.
#USAGE= pdfmerge -o output.pdf first.pdf second.pdf ... 
#ENDUSAGE%

## folder: make and enter nested directory structures
## NOTE: this is usually named 'take', so i've implemented folder as a wrapper around take.
function take() {
  [ -d "$1" ] || mkdir -p "$1" && cd "$1"
} #DESC= Create nested directory structures
#USAGE= take <NAME>
#ENDUSAGE%

function folder() {
  take $@
} #DESC= Wrapper around take
#USAGE= folder <NAME>
#ENDUSAGE%

## bak: backup files and folders.
## no dependencies.
function bak() {
  $SHELL_UTIL_DIR/scripts/bak.sh "$@"
} #DESC= Invoke backup utility script
#USAGE= bak [save|restore|help] <FILE>
# save : back up a file/folder recursively.
# restore : restore a backed-up file/folder structure.
# help : prints a more detailed help message.
#ENDUSAGE%

## trash: move something to the system trash
function trash() {
  ## check for $1
  if [ $# = 0 ]; then
	echo "$0 requires a path and optionally any additional flags accepted by 'mv'."
	return 1
  fi
  
  ## isolate target file
  target="$1"
  shift
  
  ## check for illegal flags
  case "$@" in
	"-t" | "--target-directory=" )
	  echo "Illegal option. Cannot override trash directory."
	  return 2
	;;
	"-T" | "--no-target-directory" )
	  echo "Illegal flag. Cannot unset target directory."
	  return 3
	;;
  esac
  
  mv $@ -t "$HOME/.local/share/Trash/files" "$target"
} #DESC= move a file or directory to the system trash.
#USAGE= trash <PATH> [OPTIONS]
# [OPTIONS] can be any flag recognized by the mv command, with the exception of -t/--target-directory and -T/--no-target-directory
#ENDUSAGE%

## config: easily access these config files.
## usage: config ?[--force] <path without extension>
## run config help for more usage
function config() {
	## if there are no arguments, edit the base config file as defined by $RCPATH
	if [ $# = 0 ]; then
	  $EDITOR "$RCPATH"
	  source "$RCPATH"
	  return 0
	fi
	
	## check if we should force file creation
	## will not force folder creation
	FORCE_CREATION=false
	if [ "$1" = "--force" ]; then
	  FORCE_CREATION=true
	  shift
	fi
	
	## check for help
	if [ "$1" = "help" ]; then
		echo "config(): quickly configure your shell utils."
		echo "USAGE: config <TARGET>"
		echo "VALID TARGETS:"
		echo "Any file in your SHELL_UTIL_DIR (currently $SHELL_UTIL_DIR) with the extension .sh is a valid target."
		echo "Do not include the file extension."
		echo "EXAMPLE: 'config aliases' will open the file aliases.sh in your preferred editor."
		return 0
	fi
	
	## should we make directory structures?
	if [ -f "$SHELL_UTIL_DIR/$1.sh" ]; then
		## File exists: don't create anything.
		$EDITOR "$SHELL_UTIL_DIR/$1.sh"
		source "$SHELL_UTIL_DIR/$1.sh"
	elif $FORCE_CREATION; then
		## File does not exist, but we've used --force, so create necessary folder structure
		containing_dir=$(echo "$SHELL_UTIL_DIR/$1.sh" | sed 's|/[^/]*\.sh|/|g')
		mkdir -p "$containing_dir" && touch "$SHELL_UTIL_DIR/$1.sh"
		$EDITOR "$SHELL_UTIL_DIR/$1.sh"
		source "$SHELL_UTIL_DIR/$1.sh"
	else
		## File does not exist, and we aren't forcing its creation.
		## display error and exit.
		echo "The target '$1' was not found or is not a .sh file. Use --force as the first argument to force its creation."
	fi
} #DESC= Configure config files in $SHELL_UTIL_DIR using your favorite editor
#USAGE= config <FILENAME> [--force,--help]
# --force: force file creation if the file does not already exist.
# --help: print a help message.
#ENDUSAGE%

function locate() {
  declare -a found_files
  readarray -t found_files < <(ls -1 $SHELL_UTIL_DIR | \grep -Po "[a-zA-Z0-9\-_]+\.(z)*sh")
  
  find $(printf "$SHELL_UTIL_DIR/%s " "${found_files[@]}") -type f -print0 | xargs -0 grep -Po " $1(?=\(\)|\=)"
} #DESC= Locate where an alias, functions, or variable is defined within this config
#USAGE= locate <NAME>
#ENDUSAGE%
