# Changelog

## 1.2.2 - 26/07/23
### Changed
- Remove temporary files

## 1.2.1 - 21/06/23
### Changed
- Performance improvements
  - Avoid sorting db except for display
  - Avoid forking unnecessarily, use fish builtins

## 1.2.0 - 12/04/23
### Changed
- Format output of `goto --list`
- Default to `goto --list` when no arguments given.
- Fallback on `cd` if alias not found.
- Unregister conflicting aliases when registering new ones rather than failing.

## 1.1.1 - 16/02/20
### Changed
- allow hyphens in aliases

## 1.1.0 - 19/06/19
### Changed
- `goto --list` prints sorted tab separated table

## 1.0.0 - 15/02/19
### Added
- version option
- environment variable (`GOTO_DB`) to configure goto db location

### Changed
- `goto` now follows XDG directory specification. The location of db has changed
from `$HOME/.goto` to `$XDG_DATA_HOME/goto/db`. You can migrate by running
`cat $HOME/.goto > (__goto_get_db)`


## 0.1.0 - 31/01/19
### Added
- goto command
- register, unregister, cleanup, list, expand, help options
- tab completions
