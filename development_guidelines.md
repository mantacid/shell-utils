# 1. Keep Code Readable
A good programmer can make write code that a computer can understand, but it takes a great programmer to write code that a person can understand. Avoid esoteric syntax, and comment non-obvious code with the reasoning behind it's existence.

# 2. Document All Code
Everything in this project is going to be seen and potentially modified by the end-user. Thus, it should be documented as clear as possible. Avoid excessive technical jargon. Thoroughly explain what environment variables are used for.

# 3. Keep Things Shell-Agnostic When You Can
Getting this working on any POSIX-compliant shell should be as simple as possible. To that end, developers should prioritize compatability first, and only define alternate implementations when an agnostic implementation is impossible. When different implementations have to be made, ensure that the shell chooses the correct one with no additional input from the user (ie, running the tool in bash uses the bash implementation automatically, running in fish uses its corresponding implementation, etc.).

# 4. The Primary Goal is Beginner-Friendliness.
Just because you're a poweruser, doesn't mean that a beginner will appreciate your 500 vim-like keybinds. Before you suggest a feature to be added into the source, think about whether or not a casual user will realistically use that feature. If your feature is niche, workflow-specific, or induces "emacs-pinky" or similar conditions, it's probably not right for this project.

If your code can fail, ensure that it either handles this behavior, or instructs the user what went wrong and how to fix it.

Remember, this is intended for beginners. Avoid opinionated changes unless they're biased towards user-friendliness (ie: don't set the user's default color scheme for them. Give them the knowledge to do it themselves).

# 5. Features Should be Able to Stand on Their own.
Features should not depend on each other. Don't make your features work like Microsoft Edge: the user should be able to disable your thing without breaking other things.

Similarly, avoid external dependencies. If you must use external programs, clearly denote what programs are needed, and for what purpose. If your alias/function is run with these dependencies not installed, your code should fail gracefully, ideally printing a message telling the user what needs to be fixed or installed.
