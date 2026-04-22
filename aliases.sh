### If you don't want/need an alias, comment it out.

## up: shortcut to move to parent directory
alias up='\cd ../' #DESC= Move to parent directory.

## back: moves to the directory you were last in.
alias back='\cd -' #DESC= Move to the last directory you were in.

## use colorful output for various commands
alias ls='\ls --color=auto' #DESC= List files.
alias grep='\grep --color=auto' #DESC= search for strings.

## le: list everything
alias le='\ls -la --color=auto' #DESC= List Evetything.

## handy utilities: shortened versions of common commands.
alias bye='\exit' #DESC= Short for 'exit'
alias c='\clear' #DESC= Short for 'clear'
alias edit='$EDITOR' #DESC= invoke the default editor. WARNING: may override the command 'edit'
