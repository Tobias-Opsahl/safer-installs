# Safer installs

Safer installs adds security features as default to Node and Python, reducing the risk of accidentally installing or running compromised code.

## Why

There have recently been several serious supply chain attacks in the npm and Python ecosystems. Many of these have started with attackers gaining control over popular packages through spear phishing the author and publishing malicious code as part of official package updates. Due to the heavy reliance on transitive dependencies, this can affect hundreds of other packages indirectly.

As the compromised versions of packages are often removed within a couple of hours, a lot of this can be avoided by ensuring a minimum age for all installed packages. This project ensures a minimum age of a default set to seven days, disables pre-install and post-install scripts from running and more.

## How it works

The project consists entirely of a few dotfiles and shell commands. It configures `pnpm` (for Node) and `uv` (for Python) to use better security features, most importantly by not installing packages that are newer than seven days old and by not running any code as part of the installation process. Since compromised packages are often removed within some hours, this reduces the risk of accidentally installing versions of libraries that are compromised.

Commands for `npm` and `pip` are then aliased with shell functions so that they are disabled by default, with `pnpm` and `uv` alternatives instead. This can be overridden with `command npm` or `command pip`. There is also a `safer-npx` function which emulates `npx` by creating a temporary directory, installing with `pnpm`, running it and cleaning up, which uses the configured security settings and is thus more secure.

## Setup

The settings can be set up by running `./install.sh` on macOS or Linux (there is no direct Windows support, but the files probably just need to be added to another place). This simply copies over the dotfiles and shell functions. One then have to add the following lines in `~/.zshrc` (or `~/.bashrc` or similar):

```shell
source "$HOME/.config/safer-installs/.zshrc-node"
source "$HOME/.config/safer-installs/.zshrc-python"
```

One can also skip running `./install.sh` and just copy over the files manually. The setup assumes there are no global configuration files for `pnpm` (`config.yaml`) or `uv` (`uv.toml`) already, but one can just append to them instead. They are not appended by the script to avoid unnecessary logic to match existing similar settings and such.

![no gif :(](https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExbWVlMm8wM203b3FnOWE0bDNyamhzOGVxdDF1eTdqa3gwZmh3cXlmeiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/JIX9t2j0ZTN9S/giphy.gif)
