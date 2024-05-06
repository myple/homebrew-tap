# Myple Homebrew Tap

This is the official [Homebrew] tap for [Myple]. You can use it to install Myple CLI on MacOS and Linux using Homebrew.

## Install

To install Myple CLI with Homebrew, aka. `brew`, run the following commands:

```bash
brew tap myple/tap
brew install myple
```

If you want to install a specific release, you can include the version in the command. You can also view the list of releases [here].

```bash
brew install myple@0.20.0
```

## Upgrade

To upgrade, it is recommended that you run the `brew upgrade` command. However, you can also run `myple upgrade` as well.

```bash
brew upgrade myple
```

## Uninstall

If you want to uninstall Myple CLI, run the following commands:

```bash
brew uninstall myple
brew untap myple/tap
```

[Homebrew]: https://brew.sh
[Myple]: https://myple.io
[here]: https://github.com/myple/cli/releases
