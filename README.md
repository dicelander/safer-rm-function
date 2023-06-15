:warning::warning::warning: **Warning:** This has been tested exclusively with BSD `rm` that is part of macOS Ventura and the `zsh` shell. I have no idea how it would behave with different `rm` implementations (e.g., GNU) or shells (e.g., bash). :warning::warning::warning:

# Safer rm Function

## Description

This is a short zsh function that is intended to discourage the usage of ```rm``` in favor of a tool like ```trash``` that doesn't permanently delete files. It should work as stock ```rm``` if the user provides specific, cumbersome to type, options.

The idea is to create a habit of **not** using rm instead of creating dangerous habits like aliasing ```rm``` to ```rm -i```, which could be disastrous if the user runs ```rm``` in a different machine expecting it to be interactive. Attempting to run ```trash``` in a different machine will probably return ```command not found: trash```, which should be safe.

## Pre-Installation

It is highly recommended that you install a tool like [trash](https://github.com/ali-rantakari/trash).

## Installation

1. Clone the repository
   ```zsh
   git clone https://github.com/dicelander/safer-rm-function
   ```

2. Move and rename the rm.zsh file containing the function to where you store your functions.
   If you don't have such a directory, I recommend creating it:
    ```zsh
    mkdir -p ~/.config/zsh/functions
    ```
    (Using ~/.config/zsh/functions here to adhere to the XDG spec, you can use anything you want as long as you have the right permissions)
   
   Move the rm.zsh file:
   ```zsh
   mv safer-rm-function/rm.zsh ~/.config/zsh/functions/rm
   ```
   (Here we are renaming rm.zsh to rm to autoload the function later)
   
4. Add the following lines to your `.zshrc` file to include the directory in your `fpath` (if you haven't already) and autoload the function:
    ```zsh
    # Add the functions directory to fpath
    fpath=(~/.config/zsh/functions $fpath)

    # Autoload the function
    autoload -Uz rm
    ```
5. Source the .zshrc file or open a new terminal session:
    ```zsh
    source ~/.zshrc
    ```

Alternatively, you can just place the function file wherever you want and source it with ```source /path/to/rm.zsh```.


## Usage

```zsh
rm [--ignore-warning] [--quiet-delete] [-f | -i] [-dIPRrvWx] file ...
```

Running ```rm``` as one would usually do will now display a warning to use ```trash``` instead and abort, you can add the option ```--ignore-warning``` to bypass this.
If you do so, you will see a list of files the function believes will be deleted. Type "yes" and press return to continue or anything else to abort. The list and prompt can be also bypassed by adding the option ```--quiet-delete```.

The behaviour of
```zsh
rm --ignore-warning --quiet-delete [options] file
```

should be the same as running rm without the function.

# Motivation

Was in a path like ```~/dir1/dir2/```, wanted to remove everything in ```dir1``` to start again. ```cd ..```'d to dir1 and forgot what I was doing. Came back and ```cd ..```'d again (now to $HOME) thinking I was still in dir2. Ran ```rm -rf ./*``` (and ignored the warning zsh gave me, **of course** I know what I'm doing, silly). Only noticed my mistake when a bunch of "Permission denied" messages started popping up on screen. Pretty much everything in my home dir was permanently deleted, only salvaged Desktop and Documents due to iCloud sync. With this function, and ```trash```, I've lost the habit of using rm in about a week.

# Copyright

© 2023 Victor "dicelander" Sander. This project is licensed under the terms of the [GNU General Public License v3.0](LICENSE).
