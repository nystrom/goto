# goto

A fish shell utility to quickly navigate to aliased directories supporting
tab-completion

**goto** is a port of [goto](https://github.com/iridakos/goto) to
[fish shell](https://fishshell.com/).

![demo](/demo.gif)

This is a fork of `matusf/goto` with some usage and performance improvements.
The main differences are:
- Format output of `goto --list`
- Default to `goto --list` when no arguments given.
- Fallback on `cd` if alias not found.
- Unregister conflicting aliases when registering new ones rather than failing.
- Performance improvements.

## Installation

### Via [fisher](https://github.com/jorgebucaran/fisher)

```
fisher install nystrom/goto
```

### Manually

Simply copy the [goto.fish](https://raw.githubusercontent.com/nystrom/goto/master/goto.fish)
to your `fish/functions` directory. (Typically `~/.config/fish/functions`) or run:

```
curl --create-dirs -o ~/.config/fish/functions/goto.fish https://raw.githubusercontent.com/nystrom/goto/master/functions/goto.fish
```

## Usage

### Go to an aliased directory

```
$ goto <alias>
```

### Register an alias

```
$ goto -r <alias> <directory>
$ goto --register <alias> <directory>
```

### Unregister an alias

```
$ goto -u <alias>
$ goto --unregister <alias>
```

### List aliases

```
$ goto -l
$ goto --list
```

### Cleanup non existent directory aliases

```
$ goto -c
$ goto --cleanup
```

### Expand an alias

```
$ goto -x <alias>
$ goto --expand <alias>
```

### Print goto version

```
$ goto -v
$ goto --version
```

### Print a help message

```
$ goto -h
$ goto --help
```

## Features

- support for **tab-completion** (for both, options and aliases)
- works for relative as well as absolute paths
- follows [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)

## Configuration

You can configure the location of `goto` database by setting an environment
variable `GOTO_DB` to a path to a file where you would like to store aliases.
