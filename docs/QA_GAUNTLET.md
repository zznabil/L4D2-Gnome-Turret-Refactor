# QA Gauntlet: Triple Fact-Check Checklist

The agent runs these three passes against every change, in order. The
output of each pass must satisfy its own pass criteria before the next
pass is run. Any failure stops the cycle; the agent fixes the issue
and re-runs the failed pass from the top.

> All calls are `mcp_serena_*` MCP calls. There is no shell script
> version of the gauntlet — the LSP is the only tool that can see
> inside the files.

---

## Pass 1 — Parse

**Goal:** confirm every `.c` file in `scripts/vscripts/` is parseable by
clangd. Catches truncation, accidental brace deletion, encoding
corruption.

**Procedure:**

For each `.c` file:

```
mcp_serena_get_symbols_overview
  relative_path = "scripts/vscripts/<name>.c"
  depth         = 1
```

**Pass criteria:** response contains at least one `Enum`, `Function`,
or `Variable` entry. (Even an empty file with one global returns at
least a `Variable`.)

**Fail action:** open the flagged file and inspect it. Common causes:

- A trailing brace was lost.
- A `/*` block comment was never closed.
- The file was saved with the wrong encoding (UTF-16 vs UTF-8).

---

## Pass 2 — Drift

**Goal:** confirm each tribal-duplicated helper is still reachable in
both files where it lives. Catches the case where a "duplicate" gets
orphaned because one file's copy was updated and the other wasn't.

**Known tribal duplicates** (from the project's tribal state — edit
this list when the set changes):

- `LoadSpecificConfigFile` — [lib_utils.c](file:///d:/SteamLibrary/steamapps/common/Left%204%20Dead%202/turret/scripts/vscripts/lib_utils.c) and [turret.c](file:///d:/SteamLibrary/steamapps/common/Left%204%20Dead%202/turret/scripts/vscripts/turret.c)
- `IsCertainSurvivor` — same two files
- `GetSecondarySlot` — same
- `ForcedToSwitchSecondary2` — same
- `GetButtonPressed` — same
- `GetItemAmmo`, `SetItemAmmo` — same
- `ShowSpecialHint` — same
- `CfgFileCheck` — also in [gnome_turret_trigger.c](file:///d:/SteamLibrary/steamapps/common/Left%204%20Dead%202/turret/scripts/vscripts/gnome_turret_trigger.c)
- `GenerateGnomeTurretCfgFile` — also in `gnome_turret_trigger.c`
- `GenerateGnomeVirtualInventory` — also in `gnome_turret_trigger.c`
- `GenerateGnomeVirtualInventoryReset` — also in `gnome_turret_trigger.c`
- Button bitmask constants (`FireButton`, `JumpButton`, `DuckButton`, …) — also in `gnome_turret_trigger.c`
- Per-survivor globals (`GnomeTurretNick`, `GnomeTurretAmmoCoach`, etc.) — also in `gnome_turret_trigger.c`

**Procedure:**

For each helper, run:

```
mcp_serena_find_referencing_symbols
  name_path     = "<helper>"
  relative_path = "scripts/vscripts/<fileA>.c"

mcp_serena_find_referencing_symbols
  name_path     = "<helper>"
  relative_path = "scripts/vscripts/<fileB>.c"
```

**Pass criteria:** at least one reference exists in each file. **Or**
the duplication was intentionally removed and the deletion is recorded
as a `### Removed` bullet in [CHANGELOG.md](../CHANGELOG.md) under
`## [Unreleased]`.

**Fail action:** if a "duplicate" has zero references in one file:

- The helper is dead code in that file. Either delete the duplicate, or
  merge the surviving copy into the now-orphaned file.
- If the deletion is intentional, add a changelog bullet to make the
  decision auditable.

---

## Pass 3 — Reachability

**Goal:** confirm every `.nut` file in `scripts/vscripts/` is reachable
from L4D2's entry chain. Catches "useless nut files" the user asked
about — files the engine will never load.

**Procedure:**

1. Find every `IncludeScript` call:

   ```
   mcp_serena_search_for_pattern
     substring_pattern = "IncludeScript\\s*\\(\\s*\"([^\"]+)\""
     paths_include_glob = "*.c"
     relative_path      = "scripts/vscripts"
   ```

2. Find every `vscripts = "..."` value:

   ```
   mcp_serena_search_for_pattern
     substring_pattern = "vscripts\\s*=\\s*\"([^\"]+)\""
     paths_include_glob = "*.c"
     relative_path      = "scripts/vscripts"
   ```

3. Hand-build the load graph. The starting node is **always**
   `mapspawn_addon.nut` (L4D2 auto-loads this for `AddonContent_Script 1`
   mods). Then walk:
   - `IncludeScript("X", ...)` edges from any reached node.
   - `vscripts = "X"` edges from any reached node.

**Pass criteria:** every `.nut` in `scripts/vscripts/` is in the
reachable set. **Or** every unreachable `.nut` is annotated in
`CHANGELOG.md` as `### Removed` under `## [Unreleased]` (i.e. flagged
for deletion, not a real orphan).

**Fail action:** for each unreachable `.nut` that isn't already on the
changelog's removal list, the agent must either:

- Add an edge that loads it (e.g., fix the bootstrap so the trigger
  reaches `sm_utilities.nut`).
- Annotate the changelog explaining why it stays unreachable.
- Mark the file for removal in the next cycle.

The script-level equivalent is `tools\cleanup_nut.bat`, which runs the
same logic without the MCP — useful for a quick read-only report from
the shell.

---

## Expected output on the current tree

The current project has a real load-chain bug that this gauntlet will
catch on every run until it's fixed. Expected Pass 3 output today:

```
REACHABLE: mapspawn_addon.nut         (L4D2 auto-load)
REACHABLE: gnome_turret_trigger.nut   (vscripts edge from mapspawn_addon.nut)
ORPHAN:    sm_utilities.nut           (no edge reaches it from any reachable .nut)
ORPHAN:    lib_utils.nut              (only IncludeScript target is sm_utilities.nut)
ORPHAN:    turret.nut                 (only IncludeScript target is sm_utilities.nut)
```

This is by design — the gauntlet surfaces it. Fixing the load chain is
out of scope for the tooling work; the user triages.
