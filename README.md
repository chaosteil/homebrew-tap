# homebrew-tap

Repository that contains homebrew taps for installation via homebrew.

## doist

doist is a cask. Install it with:

```bash
brew install --cask chaosteil/tap/doist
```

The tap had a formula `doist` before. `tap_migrations.json` moves the
formula to the cask of the same name. When a user of the formula runs
`brew update`, Homebrew unlinks the formula and installs the cask
([Homebrew](https://docs.brew.sh/Migrating-A-Formula-To-A-Tap),
[source](https://github.com/Homebrew/brew/blob/fc51ba6b2f144ecc94a7bf3f0b7b95c8477a5738/Library/Homebrew/cmd/update_report/reporter.rb)).
Then remove the old formula:

```bash
brew uninstall --formula --force doist
```

If Homebrew does not do the migration, for example because the tap is
not trusted, do it yourself:

```bash
brew uninstall --formula doist
brew install --cask chaosteil/tap/doist
```
