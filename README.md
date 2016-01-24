# Dotfiles

Bash prompt, environment variables, aliases and useful functions and scripts. Heavily based on other people's work (referenced within the files) - if you want to see other projects like this, visit [GitHub does Dotfiles](https://dotfiles.github.io)!

## Setup

Run the following commands to setup the contents of this repository (remember to install Git first!):

```bash
mkdir ~/workspace && cd ~/workspace
git clone https://github.com/necavit/dotfiles.git dotfiles && cd dotfiles
chmod u+x dotfiles.sh && ./dotfiles.sh && source ~/.bashrc
```

Be aware that the instructions above are customized for my own computer and personal preferences (like having a `workspace` folder in the home dir!). Feel free to install the repository wherever you want or need.

## What's here?

* `bin/`: small, useful scripts that are `chmod`'d and symlinked on `~/bin` upon installation. The `dotfiles.sh` "master" script is also symlinked there, to ease the modification of the dotfiles repository afterwards. `~/bin` is added to the `PATH`, so the scripts are always accessible.
* `img/`: just the prompt example images!
* `.bash_aliases`: `ls` and `cd` aliases, useful locations, and any other programs which name is not easy to remember.
* `.bash_env`: "permanent" environment variables exports, such as the modified `PATH`, which includes `~/bin` and `.` by default.
* `.bash_functions`: useful Bash functions, that act like extensions.
* `.bash_prompt`: the customized terminal prompt, both for the root user and the current, normal user.
* `.bashrc`: the main Bash profile customization file. There are shell options toggles and some minor tweaks. The rest of the dotfiles are sourced from this script.
* `.git_prompt`: bash/zsh Git prompt support.
* `dotfiles.sh`: the installation script for the dotfiles.

## The prompt

The user's customized prompt looks as follows:

![Customized Root Prompt](https://github.com/necavit/dotfiles/blob/master/img/prompt.png)

The time is shown, along with the username, the host machine, the current directory and, in the case that it is a Git repository, some information about it, like the current branch. If you want some more Git-related information being shown, there are other options that can be configured, as explained in the [`.git_prompt` file](https://github.com/necavit/dotfiles/blob/master/.git_prompt).

#### Root

The following prompt is shown when becoming root using a method that reads the user's `.bashrc`, such as `sudo -s`. If you are becoming root using `sudo su` or any method like that, you will need to update root's `.bashrc` file as well!

![Customized Root Prompt](https://github.com/necavit/dotfiles/blob/master/img/prompt_root.png)
