# dotfiles

Dotfiles for my standard GNU/Linux configuration

The dotfiles can automatically be applied by running `sh -c "$(curl -fsSL
https://chezmoi.io/get)" -- init --apply soni801` in your terminal. This WILL overwrite your
existing dotfiles, so make sure to have a backup.

The included run_once script should automatically run, and will download necessary
applications and dependencies before applying the configuration.

The setup script currently only supports Arch Linux and its derivatives.

