# Vim basics

Built-in Vim keys, as a cheat sheet. This config's own keys are in the [keymaps reference](/reference/keymaps).

## Modes and editing

| Keys                        | Action                                            |
| --------------------------- | ------------------------------------------------- |
| `i` / `a`, `I` / `A`        | Insert before / after cursor, at line start / end |
| `o` / `O`                   | New line below / above                            |
| `Esc`                       | Back to normal mode                               |
| `:w` / `:q` / `:wq` / `:q!` | Save / quit / both / quit without saving          |
| `u` / `Ctrl-r` / `.`        | Undo / redo / repeat last change                  |

## Move

| Keys                | Action                                  |
| ------------------- | --------------------------------------- |
| `w` / `b` / `e`     | Next word / previous word / end of word |
| `0` / `^` / `$`     | Line start / first non-blank / line end |
| `gg` / `G` / `42G`  | File start / end / line 42              |
| `%`                 | Matching bracket                        |
| `Ctrl-d` / `Ctrl-u` | Half page down / up                     |
| `Ctrl-o` / `Ctrl-i` | Back / forward in the jump list         |

Line numbers are relative, so `5j` and `3k` jump to what you see.

## Select, copy, change

| Keys                 | Action                                  |
| -------------------- | --------------------------------------- |
| `v` / `V` / `Ctrl-v` | Select characters / lines / a block     |
| `viw` / `vip`        | Select word / paragraph                 |
| `yy` / `yiw` / `p`   | Copy line / word, paste                 |
| `dd` / `x` / `ciw`   | Cut line, delete character, change word |
| `>>` / `<<`          | Indent / unindent                       |

The system clipboard isn't shared: copy to it with `<leader>y`.

## Search and replace

| Keys                   | Action                                   |
| ---------------------- | ---------------------------------------- |
| `/text` / `?text`      | Search forward / backward                |
| `n` / `N`, `*` / `#`   | Next / previous match, word under cursor |
| `:noh`                 | Clear highlight                          |
| `:%s/old/new/g` (`gc`) | Replace all (confirm each)               |

Search ignores case unless you type a capital letter.

## Windows and buffers

| Keys                | Action                 |
| ------------------- | ---------------------- |
| `:vsp` / `:sp`      | Split right / below    |
| `Ctrl-h/j/k/l`      | Move between splits    |
| `Ctrl-w q`          | Close split            |
| `Tab` / `Shift-Tab` | Next / previous buffer |
| `:bd`               | Close buffer           |
