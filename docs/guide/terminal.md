# Terminal

Terminals come from [snacks.nvim](https://github.com/folke/snacks.nvim) (`lua/plugins/terminal.lua`). They keep running while hidden and never show up in the bufferline.

- **Floating** (`Ctrl-/`): covers the editor. For a quick command.
- **Bottom split** (`<leader>ts`): sits under the editor, so you can see both.

They're separate shells. A terminal window is in **terminal mode** (typing into the shell) or **normal mode** (scroll, search and copy with Vim keys).

## Keys

| Keys           | Where                 | Action                                     |
| -------------- | --------------------- | ------------------------------------------ |
| `Ctrl-/`       | editor                | Open or show the floating terminal         |
| `Ctrl-/`       | terminal mode         | Hide the current terminal                  |
| `2 Ctrl-/`     | editor or normal mode | A second float (`3 Ctrl-/` a third, ...)   |
| `<leader>ts`   | editor                | Open, show or hide the bottom split        |
| `Esc Esc`      | terminal mode         | Normal mode (press quickly)                |
| `i`            | normal mode           | Back to terminal mode                      |
| `q`            | normal mode           | Hide the terminal                          |
| `gf`           | normal mode           | Hide it and open the file under the cursor |
| `Ctrl-h/j/k/l` | split only            | Move between windows, in either mode       |

In a float, `Ctrl-h/j/k/l` go to the shell (`Ctrl-l` clears). Don't use `Ctrl-w k` from a float: the cursor moves, but the float still covers the editor.

## Things to know

- Hiding keeps the shell running; `exit` or `Ctrl-d` ends it. A hidden terminal comes back with the key that opened it.
- Each terminal belongs to the directory it was opened in. After `:cd`, `Ctrl-/` opens a new one.
- `Esc Esc` passes one `Esc` to the shell, and zsh then swallows your next letter. Press `Ctrl-c` after `i`, or use `Ctrl-\ Ctrl-n` instead.
- If the last command failed, `exit` leaves `Terminal exited with code ...`. Press `Enter`, then `q`.

## Lazygit

`<leader>gg` opens [lazygit](https://github.com/jesseduffield/lazygit) in a float: stage lines, review diffs, rebase and resolve conflicts with single keys. Install it first (`brew install lazygit`); `?` lists its keys, `q` quits.
