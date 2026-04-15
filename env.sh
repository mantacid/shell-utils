## using some advanced syntax here. if micro is installed, then set if to the default. otherwise, use nano.
## you can use this syntax to specify precidence/preference. Neat.
export EDITOR=$(if [ -f "$(which micro)" ]; then echo "micro"; else echo "nano"; fi) #DESC= The Default editor. Uses micro if present, nano if not.
