# Completely - Bash Completions Generator

[![Gem Version](https://badge.fury.io/rb/completely.svg)](https://badge.fury.io/rb/completely)
[![Build Status](https://github.com/DannyBen/completely/workflows/Test/badge.svg)](https://github.com/DannyBen/completely/actions?query=workflow%3ATest)

---

Completely is a command line utility and a Ruby library that lets you generate
bash completion scripts from simple YAML configuration.

This tool is for you it:

1. You develop your own command line tools.
2. Your life feels empty without bash completions.
3. Bash completion scripts scare you.

---


## Install

```
$ gem install completely
```

## Usage

The `completely` command line works with a simple YAML configuration file as
input, and generates a bash completions script as output.

The configuration file is built like this:

```yaml
pattern:
  - --argument
  - --param
  - command
```

You can save a sample YAML file by running:

```
$ completely new
```

This will generate a file named `completely.yaml` with this content:

```yaml
mygit:
- --help
- --version
- status
- init
- commit

mygit status:
- --help
- --verbose
- --branch

mygit init:
- --bare
- <directory>

mygit commit:
- <file>
- --help
- --message
- --all
- -a
- --quiet
- -q
```

Each pattern in this configuration file will be checked against the user's
input, and if the input **starts with** a matching pattern, the list that 
follows it will be suggested as completions.

To generate the bash script, simply run:

```
$ completely generate

# or, to just preview it without saving:
$ completely preview
```

For more options (like setting input/output path), run

```
$ completely --help
```

### Suggesting files and directories

You may have noticed that the sample file contains two special entries:

- `<file>`
- `<directory>`

These patterns will add the list of files and directories
(when `<file>` is used) or just directories (when `<directory` is used) to
the list of suggestions.

For those interested in the technical details, any word between `<...>` will
simply be added using the [`compgen -A action`][compgen] function, so you can 
in fact use any of its supported arguments.


### Using the generated completion scripts

In order to enable the completions, simply source the generated script:

```
$ source completely.bash
```

You may wish to add this to your `~/.bashrc` file to enable this for future
sessions (just be sure to use absolute path).


## Contributing / Support

If you experience any issue, have a question or a suggestion, or if you wish
to contribute, feel free to [open an issue][issues].

---

[issues]: https://github.com/DannyBen/completely/issues
[compgen]: https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html
