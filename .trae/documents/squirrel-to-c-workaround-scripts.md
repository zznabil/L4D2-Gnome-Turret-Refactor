# Plan: Squirrel ↔ C Rename Workaround for Serena Tools

## 1. Summary

The `turret` project is a **Left 4 Dead 2 VScript mod** ("Gnome Turret Mod" v2.0 by Sw1ft) authored in Squirrel (`.nut`). Serena's C-aware tooling cannot index `.nut` files, so this plan adds a small tooling layer that:

* **`tools/nut_to_c`** — renames all `.nut` files in `scripts/vscripts/` to `.c` in place (the file the game loads is no longer present, but Serena can now read the source as C).

* **`tools/c_to_nut`** — copies every `.c` file in `scripts/vscripts/` and writes a sibling `.nut` next to it, so both extensions coexist; the L4D2 game keeps loading `.nut`, Serena keeps reading `.c`.

Both come as PowerShell (`.ps1`) and Batch (`.bat`) wrappers.

***

## 2. Deep Dive — Tribal Knowledge, Practices, Logic Flow

### 2.1 Project Layout

* Root: `d:\SteamLibrary\steamapps\common\Left 4 Dead 2\turret\`

* `addoninfo.txt` — declares `AddonContent_Script 1` (script-only VPK-less mod). `AddOnSteamAppID 550`.

* `scripts/vscripts/` — the Squirrel source tree (5 files):

  * [mapspawn\_addon.nut](file:///d:/SteamLibrary/steamapps/common/Left%204%20Dead%202/turret/scripts/vscripts/mapspawn_addon.nut) — 1 line. L4D2 auto-loaded entry for `AddonContent_Script 1` mods. Single line: `SpawnEntityFromTable("env_soundscape_triggerable", { vscripts = "gnome_turret_trigger" });`

  * [gnome\_turret\_trigger.nut](file:///d:/SteamLibrary/steamapps/common/Left%204%20Dead%202/turret/scripts/vscripts/gnome_turret_trigger.nut) — 100+ lines. Loaded by the soundscape trigger from `mapspawn_addon.nut`. Contains per-survivor state (`GnomeTurretNick`, `GnomeTurretAmmoCoach`, …), button bitmasks (`FireButton`, `DuckButton`, …), model paths, icon strings, and the first batch of helpers (`CfgFileCheck`, `GenerateGnomeTurretCfgFile`, …).

  * [sm\_utilities.nut](file:///d:/SteamLibrary/steamapps/common/Left%204%20Dead%202/turret/scripts/vscripts/sm_utilities.nut) — 1,566 lines. Orchestrator file. Last 6 lines: `IncludeScript("lib_utils", getroottable()); IncludeScript("turret", getroottable()); printl("[Turret Mod]\nAuthor: Sw1ft\nVersion: 2.0");`. The other ~1,560 lines are L4D2 mutation boilerplate (`TeleportPlayersToStartPoints`, `StartboxSpeedbump_Info`, …). **Currently ORPHAN — see §2.2 below.**

  * [lib\_utils.nut](file:///d:/SteamLibrary/steamapps/common/Left%204%20Dead%202/turret/scripts/vscripts/lib_utils.nut) — 3,074 lines. Utility library (Squirrel `class` system, ConVar/loop/tick/chat/button frameworks, math + vector + quaternion helpers). Author credit in header: "Sw1ft". **Currently ORPHAN — see §2.2 below.**

  * [turret.nut](file:///d:/SteamLibrary/steamapps/common/Left%204%20Dead%202/turret/scripts/vscripts/turret.nut) — 1,639 lines. Defines `class CTurret`, the `eTurret` enum, `PlaceTurret` / `OnUsePress` / `Turret_Think`, and registers `!debugmode` / `!remove` / `!ammo` / `!mode` chat commands. **Currently ORPHAN — see §2.2 below.**

### 2.2 Load Order & Dependencies

```
L4D2 engine
  ↓ auto-loads (well-known convention for AddonContent_Script 1)
mapspawn_addon.nut              ← 1 line; spawns the soundscape trigger
  ↓ vscripts = "gnome_turret_trigger"
gnome_turret_trigger.nut        ← per-survivor state + first batch of helpers
  ↓ (no IncludeScript, no vscripts edges)
STOP — the load chain ends here
```

**The intended load chain** (per the design of the mod, based on
`sm_utilities.nut` lines 1563-1564) **should be**:

```
mapspawn_addon.nut
  ↓ vscripts = "sm_utilities"     ← currently missing
sm_utilities.nut                 ← orchestrator
  ├── IncludeScript("lib_utils") → CEntity, RegisterOnTickFunction, …
  └── IncludeScript("turret")    → CTurret, PlaceTurret, OnAttackPress, …
```

**Tribal note**: the current bootstrap (`mapspawn_addon.nut`) points the
soundscape trigger at `gnome_turret_trigger.nut`, but `sm_utilities.nut`
is the file that actually pulls in `lib_utils` and `turret`. Nothing in
the current load chain reaches `sm_utilities.nut`. The main mod logic
(place turret, target acquisition, shoot, chat commands) is therefore
**dead code at runtime** in the as-published build. Fixing this is a
code-level change (changing the `vscripts` value in `mapspawn_addon.nut`
or adding an `IncludeScript` in `gnome_turret_trigger.nut`); it is
flagged in `CHANGELOG.md` as an open issue on the 2.0.0 release and
surfaced on every run of the QA gauntlet Pass 3.

### 2.3 Round Lifecycle

1. `OnGameEvent_round_start_post_nav` (lib\_utils) → generates `gnome turret/gnome turret.txt` and `gnome turret/virtual inventory/gnome virtual inventory.txt`, then loads both.
2. `OnGameplayStart_PostSpawn` (turret) → calls `ReplaceWeaponSpawn("weapon_upgradepack_incendiary_spawn", "weapon_gnome")` to seed gnome weapons in the map.
3. `AdditionalClassMethodsInjected` (turret) → registers chat commands `!debugmode`, `!remove`, `!ammo`, `!mode`.
4. Tick loop:

   * `OnTickCall` (lib\_utils, 0.01s) — dispatches timers, ConVar change-hooks, watchdogged try/catch per entry.

   * `ButtonsListener_Think` (lib\_utils) — fires registered button listeners.

   * `Turret_Think` (turret) — picks targets, aims bipod, applies damage, plays shoot FX, manages idle-return-to-default-angle.
5. End-of-round: `OnGameEvent_final_reportscreen` / `final_win` / `finale_vehicle_leaving` reset virtual inventory.

### 2.4 Per-Survivor Tribal State (drift risk)

Both [lib\_utils.nut](file:///d:/SteamLibrary/steamapps/common/Left%204%20Dead%202/turret/scripts/vscripts/lib_utils.nut) and [turret.nut](file:///d:/SteamLibrary/steamapps/common/Left%204%20Dead%202/turret/scripts/vscripts/turret.nut) duplicate these per-character globals:

* Gnome count: `GnomeTurretNick` `…Coach` `…Ellis` `…Rochelle` `…Bill` `…Louis` `…Francis` `…Zoey`

* Gnome ammo: `GnomeTurretAmmoNick` `…Coach` etc.

* `LoadSpecificConfigFile`, `GenerateGnomeVirtualInventory`, `GenerateGnomeVirtualInventoryReset`, `IsCertainSurvivor`, `GetSecondarySlot`, `ForcedToSwitchSecondary2`, `GetButtonPressed`, `GetItemAmmo`, `SetItemAmmo`, `ShowSpecialHint`, `CfgFileCheck`, `GenerateGnomeTurretCfgFile`.

* Bitmask button constants: `FireButton`, `JumpButton`, `DuckButton`, `ForwardButton`, `BackButton`, `UseButton`, `LeftButton`, `RightButton`, `ShoveButton`, `ReloadButton`, `ScoreButton`, `ZoomButton`.

The two copies of `LoadSpecificConfigFile` differ subtly: `lib_utils` uses `tofloat()` for `GnomeTurretDamage`; `turret.nut` uses `tointeger()`. **Do not unify them silently** — preserve the existing tribal drift.

### 2.5 Known Bug (worth flagging for Serena to find)

* [turret.nut](file:///d:/SteamLibrary/steamapps/common/Left%204%20Dead%202/turret/scripts/vscripts/turret.nut) line 1082:
  `DoEntFire("!self", "Explode", "" 0, turret.m_hOwner, ExplosionEntity);`
  — missing comma between `""` and `0`. Will throw a parse error at runtime when `ExplosionAmmoToggle == 1 || DemolitionShot >= 1`. Out of scope to fix here, but Serena will surface it after the rename.

### 2.6 Conventions & Style

* 1-tab indentation throughout.

* Section banners: `/*===============================*\\` …

* `@param`-style doc comments above public functions.

* `printl("[Tag] message")` for human logs, `printf(...)` for format strings.

* VScript's `IncludeScript(name, scope)` passes the global root table.

***

## 3. Proposed Changes

### 3.1 New Files

| Path                 | Purpose                                                                                |
| -------------------- | -------------------------------------------------------------------------------------- |
| `tools/nut_to_c.ps1` | Rename `scripts/vscripts/*.nut` → `*.c` in place.                                      |
| `tools/nut_to_c.bat` | Double-clickable wrapper that calls the .ps1.                                          |
| `tools/c_to_nut.ps1` | Copy `scripts/vscripts/*.c` → sibling `*.nut` (same dir, no overwrite of source `.c`). |
| `tools/c_to_nut.bat` | Double-clickable wrapper that calls the .ps1.                                          |
| `tools/README.md`    | One-screen operator guide (workflow + how to revert).                                  |

No existing files are modified. No `.nut` source is touched by Serena — the user runs `c_to_nut` to materialize `.nut` copies whenever the game needs them.

### 3.2 `tools/nut_to_c.ps1`

```powershell
# Renames every .nut in scripts/vscripts/ to .c in place.
# After running, the game can no longer find the script. Run c_to_nut.ps1
# to materialize .nut copies alongside the .c files for the game to load.

$ErrorActionPreference = "Stop"
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$VScripts   = Join-Path $ScriptRoot "..\scripts\vscripts"

if (-not (Test-Path $VScripts)) {
    Write-Error "scripts/vscripts/ not found at: $VScripts"
}

$files = Get-ChildItem -Path $VScripts -Filter "*.nut" -File
if ($files.Count -eq 0) {
    Write-Host "No .nut files to rename. Already in .c state."
    exit 0
}
foreach ($f in $files) {
    $newPath = [System.IO.Path]::ChangeExtension($f.FullName, ".c")
    Write-Host "  $($f.Name) -> $([System.IO.Path]::GetFileName($newPath))"
    Rename-Item -LiteralPath $f.FullName -NewName (Split-Path -Leaf $newPath)
}
Write-Host "Done. $($files.Count) file(s) renamed to .c"
```

### 3.3 `tools/nut_to_c.bat`

```bat
@echo off
setlocal
pushd "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0nut_to_c.ps1"
set "RC=%ERRORLEVEL%"
popd
endlocal & exit /b %RC%
```

### 3.4 `tools/c_to_nut.ps1`

```powershell
# Copies every .c file in scripts/vscripts/ to a sibling .nut in the same
# directory. Existing .nut files are NOT overwritten. The .c files are
# preserved so Serena can keep indexing them. After this runs, the game
# sees the .nut copies and loads them normally.

$ErrorActionPreference = "Stop"
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$VScripts   = Join-Path $ScriptRoot "..\scripts\vscripts"

if (-not (Test-Path $VScripts)) {
    Write-Error "scripts/vscripts/ not found at: $VScripts"
}

$files = Get-ChildItem -Path $VScripts -Filter "*.c" -File
if ($files.Count -eq 0) {
    Write-Host "No .c files found. Run nut_to_c.ps1 first."
    exit 0
}
$copied = 0; $skipped = 0
foreach ($f in $files) {
    $newPath = [System.IO.Path]::ChangeExtension($f.FullName, ".nut")
    $newName = [System.IO.Path]::GetFileName($newPath)
    if (Test-Path -LiteralPath $newPath) {
        Write-Host "  skip (exists): $newName"
        $skipped++
        continue
    }
    Write-Host "  $($f.Name) -> $newName"
    Copy-Item -LiteralPath $f.FullName -Destination $newPath
    $copied++
}
Write-Host "Done. $copied copied, $skipped skipped."
```

### 3.5 `tools/c_to_nut.bat`

```bat
@echo off
setlocal
pushd "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0c_to_nut.ps1"
set "RC=%ERRORLEVEL%"
popd
endlocal & exit /b %RC%
```

### 3.6 `tools/README.md` (operator-facing)

One page covering:

* Purpose (Serena-C workaround for Squirrel).

* Workflow: `nut_to_c` → use Serena → `c_to_nut` → play game.

* Round-trip safety: `c_to_nut` never overwrites and never deletes `.c`; `nut_to_c` skips non-`.nut` files.

* Idempotency: running `c_to_nut` twice is safe; running `nut_to_c` when no `.nut` exist is a no-op.

***

## 4. Assumptions & Decisions

1. **Scope is strict to the rename workflow.** No code edits, no refactor, no bug-fixing the missing-comma in `turret.nut` line 1082. Serena is expected to surface that and similar issues post-rename.
2. **`mapspawn_addon.nut`** **is treated as in-scope for the rename** even though nothing imports it, because the user's stated rule is "rename the squirrel nut files" — i.e. all of them. It costs nothing and stays reversible.
3. **Working directory is fixed to** **`scripts/vscripts/`.** Scripts resolve paths relative to their own location (`$ScriptRoot/..\scripts\vscripts`) so they work regardless of where they're invoked from.
4. **`.c_to_nut`** **does not overwrite an existing** **`.nut`.** This protects the user from accidentally clobbering real source if they hand-edited the `.nut` and forgot to re-rename. The script reports the skip so nothing is silent.
5. **PowerShell + Batch pair (per user choice).** Both call the same logic so there's a single source of truth.
6. **No new project-level config or git hooks.** The user's project has no VCS in the explored tree; adding hooks would be over-engineering.
7. **Windows-only.** The user is on Windows (PowerShell 7+ per environment note). No POSIX shell variant.

***

## 5. Verification

After implementation, run from `d:\SteamLibrary\steamapps\common\Left 4 Dead 2\turret\`:

1. **Baseline:** confirm initial state in `scripts/vscripts/` — five `.nut` files, zero `.c` files.

   ```powershell
   Get-ChildItem scripts\vscripts | Select-Object Name
   ```
2. **Run** **`nut_to_c`:** `.\tools\nut_to_c.bat` → expect 5 `.c` files, 0 `.nut` files. Serena should now find the project.
3. **Run** **`c_to_nut`:** `.\tools\c_to_nut.bat` → expect 5 `.c` + 5 `.nut` (5 "copied", 0 "skipped").
4. **Idempotency:** re-run `.\tools\c_to_nut.bat` → expect 0 copied, 5 skipped, exit 0.
5. **Round-trip:** delete one `.nut`, re-run `c_to_nut` → that one shows "copied", others "skipped". Confirms partial recovery.
6. **Open a** **`.c`** **in Serena** (or any C-syntax highlighter) — should syntax-highlight without "unknown file type" warnings.
7. **No** **`.nut`** **was modified** — the original source of truth (`scripts/vscripts/*.nut` prior to step 2) is untouched by `c_to_nut` (it writes new copies; never edits existing `.nut`).

