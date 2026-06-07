# QA Verification Report — AGENTS.md

**Date:** 2026-06-06
**Scope:** Read-only verification of all AGENTS.md factual claims against source files
**Files verified:** AGENTS.md, all 5 .c files, tools/*.ps1, tools/*.bat, .omo/boulder.json, docs/QA_GAUNTLET.md, CHANGELOG.md

---

## CHECK 1 — Load Chain Claims ✅

| Claim | Source | Verification |
|-------|--------|-------------|
| `IncludeScript("sm_utilities")` at line 973 in trigger.c | AGENTS.md:21 | `gnome_turret_trigger.c:973` — `IncludeScript("sm_utilities", getroottable())` ✅ |
| `IncludeScript("lib_utils")` at line 1565 in sm_utilities.c | AGENTS.md:21 | `sm_utilities.c:1565` — `IncludeScript("lib_utils", getroottable())` ✅ |
| `IncludeScript("turret")` at line 1566 in sm_utilities.c | AGENTS.md:21 | `sm_utilities.c:1566` — `IncludeScript("turret", getroottable())` ✅ |
| `::` operator exports at lines 975-1051 | AGENTS.md:21 | Verified: `::` exports span 975 (`::LoadSpecificConfigFile`) to 1051 (`::g_flGnomeTurretSweepArc`) ✅ |

**Load chain diagram matches source code exactly** ✅

---

## CHECK 2 — Per-Survivor Globals Removed from turret.c ✅

- Grep for `GnomeTurretNick|GnomeTurretCoach|GnomeTurretEllis|GnomeTurretRochelle` in turret.c: **zero matches** ✅
- Grep for function definitions (`function IsCertainSurvivor|...`) in turret.c: **zero matches** ✅
- All per-survivor globals (16 vars: 8 survivors × gnome count + ammo count) defined at `gnome_turret_trigger.c:4-20`
- All exported via `::` at `gnome_turret_trigger.c:999-1015` ✅
- AGENTS.md claim: "turret.c no longer redefines these functions or the per-survivor globals" — **confirmed** ✅

---

## CHECK 3 — TurretDataSaveTimer at turret.c Top ✅

- `turret.c:4`: `TurretDataSaveTimer <- 0`
- No other top-level variables in turret.c
- Line 7+: `class CTurret` begins
**Confirmed** ✅

---

## CHECK 4 — Tool Gotcha Claims ✅

| Claim | File:Line | Verification |
|-------|-----------|-------------|
| `dev_cycle.ps1` pauses with `Read-Host` at line 53 | `dev_cycle.ps1:53` | `$ok = Read-Host "    Type 'gauntlet passed' to continue"` ✅ |
| `build_vpk.bat` auto-closes with 5-second countdown (lines 25-28) | `build_vpk.bat:25-28` | `for /l %%i in (5,-1,1)` loop with `ping -n 2` delay ✅ |
| `build_vpk.ps1` cleans `dist/` at line 21 | `build_vpk.ps1:21` | `Remove-Item -Path "$DistDir\*" -Recurse -Force` ✅ |
| `c_to_nut.ps1` silently skips existing `.nut` | `c_to_nut.ps1:24` | `Write-Host "  skip (exists): $newName"` ✅ |

All claims verified against tool source files ✅

---

## CHECK 5 — .omo Directory Structure ✅

| Path | Exists? |
|------|---------|
| `.omo/boulder.json` | ✅ |
| `.omo/plans/` | ✅ |
| `.omo/run-continuation/` | ✅ |
| `.omo/notepads/` | ✅ |

---

## CHECK 6 — No opencode.json ✅

- Test-Path for `opencode.json` in project root: **False** ✅
- AGENTS.md claim confirmed ✅

---

## CHECK 7 — Serena Parse Pass ✅

All 5 `.c` files return valid symbol data from `serena_get_symbols_overview`: ✅

- `mapspawn_addon.c` — 1 function ✅
- `gnome_turret_trigger.c` — 23 functions ✅
- `sm_utilities.c` — 44 functions ✅
- `lib_utils.c` — 200+ Variables, 4 Enums, 70+ Functions ✅
- `turret.c` — 1 Enum, 1 Variable, 24 Functions ✅

---

## CHECK 8 — Stale Content Scrub ✅

- Searched for: `ORPHAN`, `orphan`, `✗`, `dead`, `unreachable`, `stale`
- No stale orphan markers or outdated status claims found ✅

---

## CHECK 9 — boulder.json Consistency ✅

- 2 completed tasks (todo:1 fix stale content, todo:2 add new sections)
- Work status: `active`, plan path exists
- **No contradictions with AGENTS.md** ✅

---

## ⚠️ DISCREPANCIES FOUND (in downstream files, not AGENTS.md)

### DISCREPANCY A: QA_GAUNTLET.md §Pass 2 lists turret.c duplicates that no longer exist

- **File:** `docs/QA_GAUNTLET.md:48-63`
- **Issue:** Known tribal duplicates list still references `turret.c` for functions that were removed (now accessed via `::` exports)
- **Verification:** Grep for function definitions in turret.c returned **zero matches**
- **Effect:** QA Pass 2 (Drift) will produce false failures
- **Recommendation:** Update QA_GAUNTLET.md §Pass 2 to reflect current state

### DISCREPANCY B: CHANGELOG.md still describes old orphan state

- **File:** `CHANGELOG.md:31-36`
- **Issue:** Notes section states the load chain "is not reachable" — outdated since the fix
- **Recommendation:** Add load chain fix to `[Unreleased]` → `### Fixed`

### DISCREPANCY C (MINOR): dist/turret.vpk exists but content unverified

- AGENTS.md claim that VPK deployment is "unconfirmed" is accurate
- File exists but we cannot verify it contains the fix without extraction

---

## VERDICT: ALL 9 CHECKS PASS ✅

AGENTS.md is factually accurate against source code. 2 discrepancies found in downstream files (QA_GAUNTLET.md, CHANGELOG.md) that reference outdated state — these are not AGENTS.md issues.