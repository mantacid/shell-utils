# About
These files contain aliases, functions, and scripts designed for user-friendliness. They are intended to be memorable, but ultimately discarded as you gain confidence in using a linux shell (like an anime protagonist with their training weights).
These aliases are intended to be shell-agnostic, but I couldn't test them in every shell. If you come across any problems, let me know by opening an issue (or a pull request if you can fix them).

## Motivation
Many people who want to use linux are being held back by a fear of the command line. When I started, I was one of them. This project aims to smooth the transition from casual desktop use to command-line proficiency. It is not intended to be suitable for power-users without extensive modification; the primary focus is on those just starting out with the terminal.
To that end, I've made a few opinionated changes that I think a beginning linux user would find handy:
- Easy-to-intuit aliases for directory navigation
- A function that can quickly open this project's files in an editor
- Sane defaults for casual users.

If you have suggestions for aliases, functions, or other utilities, open an issue!

# Installation
First, clone the repository into your `.config` directory:
```shell
cd ~/.config
git clone https://github.com/mantacid/shell-utils.git
```

Next, you'll need to edit your shell's config file (or create it if there isn't one there):
| if you use... | ... then your config file is at: |
| ------------- | -------------------------------- |
| bash          | `~/.bashrc`                      |
| zsh           | `~/.zshrc`                       |
| ash           | `~/.profile`                     |

add the following lines to the top of the file IN ORDER (you can leave out comments, but I personally wouldn't do that):
```shell
## if you've cloned this repo to somewhere other than $HOME/.config/shell-utils, then change this path accordingly
## this tells your shell where to look for the config files.
export SHELL_UTIL_DIR="$HOME/.config/shell-utils"
## this variable tells the other files where to find the main config file. Set this according to the table above.
export RCPATH="$HOME/.bashrc" # bash by default. change if necessary.
source "$SHELL_UTIL_DIR/env.sh"
source "$SHELL_UTIL_DIR/aliases.sh"
source "$SHELL_UTIL_DIR/functions.sh"
```
Save these changes, then exit your editor.
Finally, restart your shell to apply the changes.
## Companion Tools
These are a few tools that can be installed alongside this config for extra functionality. Each tool has a respective config file in the `configs` directory. Some tools are geared more towards the terminal's appearance, while others are included for the features they provide.
### BLE: bash line editor
Syntax highlighting and command auto-completion for bash interactive shells. If you're using zsh, there should be a plugin you can get through [zinit](https://github.com/zdharma-continuum/zinit?tab=readme-ov-file#ice-modifiers) that does the same things.
[BLE](https://github.com/akinomyoga/ble.sh)

### Starship: Fast and Informative prompt.
Customizes the prompt to show additional information, like git status, version info, command status, and more.
[Starship](https://github.com/starship/starship?tab=readme-ov-file)

- - - 
# Environment
Exported evnironment variables are defined in the file `env.sh`.
The environment contains variables and values your system uses to perform its job. It keeps track of what directory you're in, what shell you're using, what command you ran last, what editor you prefer, and more.
If you use any of the other files in this repository, you **MUST** first `source` this one, otherwise critical values will not be defined.
## Variables Set By the main configuration file
### `SHELL_UTIL_DIR`
The absolute path to this repository. if you followed the installation instructions, this should be `$HOME/.config/shell-utils/`.
### `RCPATH`
Points to the main shell config file. Defaults to `$HOME/.bashrc`. You will need to change this if using a different shell.
## Variables set by `env.sh`
### `EDITOR`
denotes the default editor to use. The default behavior is to use `micro` if it is installed, falling back to `nano` if `micro` cannot be found in your `PATH`.

# Aliases
All aliases are stored in the file `aliases.sh`.
For those unfamiliar, an alias is like a "macro" for the command line. When an alias is evaluated, it "expands" into its definition.
Aliases are defined using the shell-built-in `alias`:
```shell
alias up='cd ../'
```
When the shell evaluates `up`, it will first expand it into `cd ../`, then execute the full command.

Aliases have a couple of limitations:
1. If you want any form of complex argument parsing, you're out of luck. You'd be better off using functions.
2. Aliases don't seem to expand other aliases inside them. There's probably a reason for this, but I don't know what it is.
3. It is possible to overwrite other commands. The consequences of this vary from "none at all" to "overwriting critical functionality".

>[!NOTE]
If you have overwritten a command using an alias, and wish to temporarily ignore the alias, you can prefix the command with a backslash.

## Included Aliases:
### up
This will navigate to the parent directory.
```shell
alias up='cd ../'
```
### back
This will navigate to the directory you were last in.
```shell
alias back='cd -'
```
### folder
Oftentimes when installing a program from source, you'll be asked to make a directory and immediately cd into that directory. With `folder`, you can make then enter nested folder structures.
```shell
alias folder='[ -d "$1" ] || mkdir -p "$1" && cd "$1"'
```
#### Explanation:
First, we use `[ -d "$1" ]` to check if the path already exists, since there's no point in doing anything if it does.
If it doesn't (`||`), we then make a directory (`mkdir`) with that path (creating folders as needed with `-p`). If that succeeds (`&&`), we then `cd` into the newly-made directory.
### le
**L**ist **E**verything
```shell
alias le='la -la'
```

### edit: edit files
Invokes the default editor.
```shell
alias edit='$EDITOR'
```

# Functions
All functions are stored in the file `functions.sh`.
Functions are more complex, as they are a series of commands in their own right, rather than a simple substitution. They can be defined using the following syntax:
```shell
function my_function() {
  # function body here
}
```
Nothing goes inside the parentheses, regardless of whether `my_function` takes any arguments.
Arguments are referenced by their position, using a dollar-sign and then a number: `$0` will always be the function's name, and `$1` will be the first argument to the function.

I often use functions as wrappers around more complex scripts. This allows me to keep the functions neat and readable, and the actual code compartmentalized and organized. if you see a function that looks like this:
```shell
function wrapper() {
  $SHELL_UTIL_DIR/scripts/myScript.sh "$@"
}
```
then it's probably running something from the `scripts/` folder, and just passing all of its arguments directly to the script.

## Included Functions
### pdfmerge
Calls `$SHELL_UTIL_DIR/scripts/pdfmerge.sh`. Expects the flag `-o` and a filename for the output, then two more paths to pdfs to merge. the second will be appended to the first, then saved to the file given to `-o`. Requires bash and ghostscript to be installed.

### bak
Creates backups of files and folders. Running `bak save foo` will clone the file/folder `foo` and all its contents to a new file/folder `foo.bak`. Running `bak restore foo` will look for a backup of `foo` in the current directory and, if one is found, replace the original `foo` with `foo.bak`. Running `bak help` will display a similar explanation to this.

in reality, this function calls `$SHELL_UTIL_DIR/scripts/bak.sh`.
Note that you must be in the directory containing the target file/folder! Saving won't behave unexpectedly, but loading will fail if the backup is not found in the current working directory.

### trash
Moves a file to `$HOME/.local/share/Trash/files`. The first argument is the file/directory to move to the trash, and is required. subsequent arguments are optional, and can be any flag accepted by `mv`, with the exception of `-t`, `--target-directory`, `-T`, and `--no-target-directory`.

### config
`config` takes the name of any shell file within the shell-utils repository, and opens it in your preferred editor. For example, running `config aliases` will open `aliases.sh` in the preferred editor as defined by the environment variable `$EDITOR`. Running `config` without any arguments will open the main shell configuration file, as defined in the variable `RCPATH`. Files within nested directories can also be accessed. This function will fail if no `.sh` files matching the given name can be found in the shell-util directory. Using the flag `--force` before the target will create the file at the given path relative the the shell-util directory.
The config will be automatically sourced by the shell, but this will not UNSET any variables.
>[!NOTE]
If using `zsh`, you may want to change the extension that the function checks for from `.sh` to `.zsh`. This is as simple as doing a find-and-replace using your favorite text editor.

