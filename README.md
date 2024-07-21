# auto-touch-on-save.vim

A flexible Vim plugin that allows you to automatically execute a custom command (e.g., touch) on file save, with customizable conditions and path conversion.

## Motivation

This plugin was created to address a specific issue that arises when working with shared mounted files between a host system and virtual environments or containers. In such setups, system constraints may prevent inotify from functioning properly, which can lead to file change detection problems.

The primary goal of auto-touch-on-save.vim is to provide a workaround for this issue by executing a `touch` command on the guest system whenever a file is saved on the host. This ensures that file changes are properly detected and propagated, even when the standard file system notifications are not working as expected.

By offering customizable conditions and path conversion, this plugin allows users to tailor its behavior to their specific development environments and workflows, making it a versatile tool for developers working with various virtualized or containerized setups.

## Features

- Execute custom commands on file save
- Customizable conditions for command execution
- Flexible path conversion to support various workflows (e.g., local to remote path conversion)
- Support for both Vim functions and external commands for condition checking and path conversion
- Automatic file reload after touch to prevent unnecessary "file changed" warnings

## Installation

Using [vim-plug](https://github.com/junegunn/vim-plug):

```viml
Plug 'na0x2c6/auto-touch-on-save.vim'
```

Or manually:

1. Create the directory `~/.vim/pack/plugins/start/auto-touch-on-save/`
2. Copy the contents of this repository into that directory

## Configuration

Add the following to your `.vimrc` file:

```viml
" Set the condition for executing the command (optional)
let g:auto_touch_on_save_condition = 'custom_condition_script.sh'

" Set the command to be executed (optional)
let g:auto_touch_on_save_command = 'custom_touch_command.sh'

" Set the path converter (optional)
let g:auto_touch_on_save_path_converter = 'sed "s|^/home/user|/remote/path|"'

" Or set a Vim function for path conversion (optional)
function! CustomPathConverter(path)
  " Your custom path conversion logic here
  return converted_path
endfunction
let g:AutoTouchOnSavePathConverter = function('CustomPathConverter')
```

### Default Values

- `g:auto_touch_on_save_condition`: 'true' (always execute)
- `g:auto_touch_on_save_command`: 'touch'
- `g:auto_touch_on_save_path_converter`: '' (no conversion)
- `g:AutoTouchOnSavePathConverter`: Not set by default

### Path Conversion Priority

1. If `g:AutoTouchOnSavePathConverter` is defined as a Vim function, it will be used for path conversion.
2. If `g:AutoTouchOnSavePathConverter` is not defined, but `g:auto_touch_on_save_path_converter` is set to a non-empty string, it will be used as an external command for path conversion.
3. If neither is set, no path conversion will be performed.

## Usage Examples

### Basic Usage

```viml
" Touch the file on every save
let g:auto_touch_on_save_command = 'touch'
```

### Custom Condition

```viml
" Only touch the file if a certain condition is met
let g:auto_touch_on_save_condition = 'test -f /path/to/flag/file'
```

### Path Conversion using Vim Function

```viml
function! ConvertPath(path)
  return substitute(a:path, '^/home/user', '/remote/path', '')
endfunction

let g:AutoTouchOnSavePathConverter = function('ConvertPath')
```

### Path Conversion using sed Command

```viml
" The command will receive the path via stdin and should output the converted path
let g:auto_touch_on_save_path_converter = 'sed "s|^/home/user|/remote/path|"'
```

This example uses `sed` to replace `/home/user` at the beginning of the path with `/remote/path`.

### [podman machine](https://docs.podman.io/en/latest/markdown/podman-machine.1.html) Example

```viml
" The condition checks if a Podman machine is running.
let g:auto_touch_on_save_condition = 'podman machine list --format "{{ .Running }}" | grep -q true'
" The command uses `podman machine ssh` to execute the `touch` command inside the Podman machine.
let g:auto_touch_on_save_command = 'podman machine ssh -- touch'
```
