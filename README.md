# rofi configuration

The launcher and every menu of the ACO desktop, built on [rofi](https://github.com/davatorium/rofi) (2.x, native Wayland).
A centred, Spotlight-like search window: large input, app icons with a quiet subtitle, the selection as an accent pill.

| Key / command | What opens |
| --- | --- |
| `Super + Space` (also `Alt + Space`, `Super + D/R/A`), `aco-menu apps` | Apps, with tabs for open windows (and *Rechner*/*Emoji* when `rofi-calc`/`rofi-emoji` are installed); `Ctrl + Tab` switches tabs |
| `aco-menu windows` | Open windows |
| `… \| aco-menu [options]` | Any list a script passes in (dmenu); used by settings, power menu, window switcher, monitors, wallpaper, shortcuts and sudo password prompt |

Pressing the same key again closes an open menu. `aco-menu --help` lists the options (`--prompt`, `--placeholder`,
`--message`, `--lines`, `--width`, `--password`, `--icons`, `--grid`, `--index`, `--markup`). Esc exits with status 1, a
menu closed from outside with 130.

No daemon: rofi only runs while a menu is open. Measured in the (fully emulated) test VM: about 42 MB while open,
nothing afterwards.

Package: `aco-arch-dotfiles-rofi`, command `aco-menu`. Entry points: `~/.config/rofi/config.rasi` (behaviour) and
`~/.config/rofi/themes/aco.rasi` (layout).

### Theme and customisation

`themes/aco.rasi` holds the whole layout (sizes, spacing, which widgets appear) and imports the colours, font and rounding
that [aco-theme](https://github.com/Akademie-Olympia/aco-theme) renders to `~/.config/aco/theme/rofi/colors.rasi`
(variables `@aco-surface`, `@aco-accent`, `@aco-radius`, …). Change any rule in your user copy; `rofi-theme(5)` documents
every property. `aco-menu --grid` and `--width` add small per-menu tweaks on top.

Your own changes in the activated user copy survive synchronisation; new differing defaults appear as `.pacnew`.

Dependencies: rofi ≥ 2.0, adwaita-icon-theme, kitty (terminal apps), aco-theme. Details: [PACKAGING.md](PACKAGING.md).
[MIT licence](LICENSE).
