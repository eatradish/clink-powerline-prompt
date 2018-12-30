# clink-powerline-prompt

## Preview

![Preview](https://raw.githubusercontent.com/namorzyny/clink-powerline-prompt/master/preview.jpg)

## Requirements

- [Nerd Fonts](https://nerdfonts.com/)
- [clink](https://mridgers.github.io/clink/) or [cmder](http://cmder.net/)

## Installing

### For clink users

Put the file [clink-powerline-prompt.lua](https://github.com/namorzyny/clink-powerline-prompt/raw/master/clink-powerline-prompt.lua) into **%LOCALAPPDATA%\clink**

### For cmder users

Put the file [clink-powerline-prompt.lua](https://github.com/namorzyny/clink-powerline-prompt/raw/master/clink-powerline-prompt.lua) into **(cmder)\config**

## Options

You can configure it by setting your user environment variables, such as changing colors or visibility of segments.

Available colors:

- BLACK, BRIGHT_BLACK
- RED, BRIGHT_RED
- GREEN, BRIGHT_GREEN
- YELLOW, BRIGHT_YELLOW
- BLUE, BRIGHT_BLUE
- MAGENTA, BRIGHT_MAGENTA
- CYAN, BRIGHT_CYAN
- WHITE, BRIGHT_WHITE

### Order

`POWERLINE_PROMPT_ORDER` defines the order of prompt segments, e.g. `path git tail`.

### Prompt

|Variable|Default|
|--------|-------|
|POWERLINE_PROMPT_CHAR|$|
|POWERLINE_ADMIN_PROMPT_CHAR|#|
|POWERLINE_PROMPT_CHAR_COLOR|BRIGHT_GREEN|
|POWERLINE_ADMIN_PROMPT_CHAR_COLOR|BRIGHT_YELLOW|

### Separator

|Variable|Default|
|--------|-------|
|POWERLINE_SEGMENT_SEPARATOR||
|POWERLINE_INNER_SEPARATOR||

### Clock

|Variable|Default|
|--------|-------|
|POWERLINE_CLOCK_BG|WHITE|
|POWERLINE_CLOCK_FG|BLACK|

### Path

|Variable|Default|
|--------|-------|
|POWERLINE_PATH_BG|WHITE|
|POWERLINE_PATH_FG|BLACK|
|POWERLINE_ICON_HOME||
|POWERLINE_ICON_DRIVE||

### Git

|Variable|Default|
|--------|-------|
|POWERLINE_ICON_BRANCH||
|POWERLINE_ICON_COMMIT|ﰖ|
|POWERLINE_GIT_BG|WHITE|
|POWERLINE_GIT_FG|BLACK|
|POWERLINE_ICON_CLEAN||
|POWERLINE_ICON_STAGED||
|POWERLINE_ICON_UNSTAGED||
|POWERLINE_ICON_UNMERGED||
|POWERLINE_ICON_UNTRACKED||
|POWERLINE_GIT_ICON_CLEAN_COLOR|GREEN|
|POWERLINE_GIT_ICON_STAGED_COLOR|BLUE|
|POWERLINE_GIT_ICON_UNSTAGED_COLOR|YELLOW|
|POWERLINE_GIT_ICON_UNMERGED_COLOR|RED|
|POWERLINE_GIT_ICON_UNTRACKED_COLOR|MAGENTA|

### Readonly

|Variable|Default|
|--------|-------|
|POWERLINE_READONLY_BG|RED|
|POWERLINE_READONLY_FG|WHITE|
|POWERLINE_ICON_READONLY||
