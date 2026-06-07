# SDLC + QA Workflow for the Gnome Turret Mod

This is the operating procedure for the project. It assumes you edit
`.c` files only and that the `.nut` files are generated artifacts the
L4D2 game engine loads. Serena's LSP is the QA gauntlet because Squirrel
has no compiler, syntax-checker, or test runner available on this
machine.

For the LSP tools themselves, see [SERENA_LSP_GUIDE.md](SERENA_LSP_GUIDE.md).
For the gauntlet step-by-step, see [QA_GAUNTLET.md](QA_GAUNTLET.md).
For the in-game feedback questions, see [FEEDBACK_TEMPLATE.md](FEEDBACK_TEMPLATE.md).

---

## 1. Roles

| Role | Who | Responsibility |
|---|---|---|
| Author | The agent (LLM) | Edits `.c`, runs the gauntlet, publishes `.nut`, builds `.vpk`, writes CHANGELOG entries. |
| Reviewer | The agent (LLM) | Same entity, post-edit — runs Parse / Drift / Reachability against the changes. |
| Tester | The user | Drops the `.vpk` into L4D2, plays a map, reports back via the feedback template. |
| Release manager | The agent (LLM) | Curates `RELEASE_NOTES.md`, cuts versions, tags the changelog. |

There is no VCS and no CI. The "reviewer" is a checklist the agent
follows, not a separate human.

---

## 2. Phases

The full cycle repeats per change.

### 2.1 Phase 0 — Session start
1. `cd` to the project root.
2. `tools\nut_to_c.bat` — ensures the `.c` view is current. (If a `.nut`
   was edited by hand, this converts it; if a `.c` was edited in the
   previous session and never published, this overwrites the `.nut`
   temporarily so the game can run for the user's last test.)
3. `mcp_serena_activate_project` — once per session.

### 2.2 Phase 1 — Edit (`.c` only)
Open `scripts/vscripts/*.c` and make the change. Never edit `.nut`
directly; treat it as build output.

### 2.3 Phase 2 — QA gauntlet
Run the three passes from [QA_GAUNTLET.md](QA_GAUNTLET.md):
1. **Parse** — `get_symbols_overview` per file.
2. **Drift** — `find_referencing_symbols` for each tribal-duplicated helper.
3. **Reachability** — `search_for_pattern` for `IncludeScript` + `vscripts = "..."`; build the load graph; flag orphans.

If any pass fails, stop. Fix and re-run. Do not proceed to Phase 3 with a
known broken state.

### 2.4 Phase 3 — Publish
`tools\publish.bat` overwrites the `.nut` from the `.c`. This is
intentionally destructive — `c_to_nut.bat` is the non-destructive
variant for when you want both to coexist.

### 2.5 Phase 4 — Build
`tools\build_vpk.bat` invokes the real `vpk.exe` and produces
`dist/<addonname>.vpk`.

### 2.6 Phase 5 — User test
The user drops the `.vpk` into their L4D2 `addons/` folder, launches
L4D2, and plays a map.

### 2.7 Phase 6 — Feedback
The agent asks the questions in [FEEDBACK_TEMPLATE.md](FEEDBACK_TEMPLATE.md).
The user answers; the agent triages.

### 2.8 Phase 7 — Changelog
If the change is user-visible, the agent adds a bullet under
`## [Unreleased]` in `CHANGELOG.md`. If the user says "good, ship it",
the agent cuts a release:

1. Rename `## [Unreleased]` to `## [VERSION] - YYYY-MM-DD` in `CHANGELOG.md`.
2. Add a `## vX.Y.Z` block to `RELEASE_NOTES.md` with the highlights
   curated for the Workshop description.

---

## 3. Why `.c` is the source of truth

L4D2 only loads `.nut`. But the only viable analysis surface we have
is `clangd` (the C/C++ language server Serena uses), and `clangd` does
not understand `.nut`. So:

- `.c` is the file the author writes. It is the only file Serena can
  reason about.
- `.nut` is generated. It is what the game loads.
- They must match byte-for-byte. `publish.bat` enforces this.

This is not a "build a compiler" project. It's a thin shim that uses
the wrong parser (C) on a language it doesn't fully understand
(Squirrel), and gets most of the way there because Squirrel's grammar
is C-shaped. The gauntlet compensates for the cases where that doesn't
hold.

---

## 4. File hygiene rules

1. **One `.nut` per `.c`, same basename.** The rename scripts enforce
   this. Don't introduce `<name>_v2.nut` siblings.
2. **No `.nut` outside `scripts/vscripts/`.** The auto-load path is
   fixed; deviating breaks the L4D2 entry chain silently.
3. **No edits to `.nut` directly.** If a hotfix is needed, edit the
   `.c`, then `publish.bat`. If a hotfix is *only* needed in the `.nut`
   (e.g. a one-character typo), the next `nut_to_c.bat` will overwrite
   the `.c` with the typo — fix it in the `.c` first.
4. **Add new files via the gauntlet.** A new `.nut` that isn't
   reachable from the L4D2 entry chain will be flagged in Pass 3
   (Reachability) and again by `cleanup_nut.bat`.

---

## 5. When things break

### Serena returns nothing
- Make sure you activated the project.
- Make sure the file is `.c`, not just `.nut`.
- If you just renamed, give the indexer a moment.

### The gauntlet flags `sm_utilities.nut` as an orphan
This is the **current real state of the project**. `sm_utilities.nut`
includes `lib_utils.nut` and `turret.nut` at the bottom, but nothing
in the load chain reaches it. The actual game logic (place turret,
target acquisition, shoot, chat commands) is currently **dead code at
runtime**. Fixing the load chain is out of scope for the tooling
work; this is a code-level bug the user must triage.

### `vpk.exe` not found
Update the absolute path at the top of `tools/build_vpk.ps1`. The
default is `D:\SteamLibrary\steamapps\common\Left 4 Dead 2\bin\vpk.exe`.

### `clangd` not on PATH
```powershell
winget install --id LLVM.Clangd --accept-source-agreements --accept-package-agreements --silent
refreshenv
```

---

## 6. See also

- [QA_GAUNTLET.md](QA_GAUNTLET.md) — the three fact-check passes in checklist form.
- [FEEDBACK_TEMPLATE.md](FEEDBACK_TEMPLATE.md) — what the agent asks after the user plays the build.
- [SERENA_LSP_GUIDE.md](SERENA_LSP_GUIDE.md) — how to use the `mcp_serena_*` tools day-to-day.
- [../CHANGELOG.md](../CHANGELOG.md) — version history.
- [../RELEASE_NOTES.md](../RELEASE_NOTES.md) — curated highlights per release.
- [../tools/README.md](../tools/README.md) — script reference (rename, publish, build_vpk, cleanup_nut, dev_cycle).
