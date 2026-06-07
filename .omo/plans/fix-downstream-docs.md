# Plan: Fix Stale Downstream Docs to Match Fixed Load Chain

## TL;DR

> **Quick Summary**: Fix two downstream documentation files that still reference the pre-fix orphan state, causing confusion now that AGENTS.md correctly documents the fixed load chain.

> **Deliverables**:
> - Updated `docs/QA_GAUNTLET.md` §Pass 2 — remove turret.c from tribal duplicates list
> - Updated `CHANGELOG.md` — replace "not reachable" note with "fixed" note under `[Unreleased]`

> **Estimated Effort**: Quick
> **Parallel Execution**: YES — 2 independent files
> **Critical Path**: None (both tasks independent)

---

## Context

### Original Request
During the `update-agents-md` plan QA verification, two downstream discrepancies were found:

1. `docs/QA_GAUNTLET.md` §Pass 2 lists `turret.c` as hosting tribal duplicate functions that were removed (now accessed via `::` exports). Running Pass 2 would produce false failures.
2. `CHANGELOG.md` notes section still says the load chain "is not reachable" — outdated since the `IncludeScript("sm_utilities")` fix was applied to source code.

### What We Know
- turret.c no longer defines `LoadSpecificConfigFile`, `CfgFileCheck`, `GenerateGnomeTurretCfgFile`, or any of the other 12+ tribal duplicates
- Those functions are now accessed via `getroottable()` exports from `gnome_turret_trigger.c`
- The load chain fix is in source code (gnome_turret_trigger.c:973)
- AGENTS.md correctly documents this

---

## Work Objectives

### Core Objective
Update two downstream documentation files to match the current fixed state documented in AGENTS.md.

### Concrete Deliverables
- Updated `docs/QA_GAUNTLET.md` — Pass 2 tribal duplicates list corrected
- Updated `CHANGELOG.md` — `[Unreleased]` section with load chain fix noted

### Must Have
- QA_GAUNTLET.md Pass 2 no longer flags turret.c for tribal duplicates that were removed
- CHANGELOG.md `[Unreleased]` section documents the load chain fix

### Must NOT Have
- Do NOT modify source code (.c/.nut files)
- Do NOT run publish.bat or build_vpk.bat
- Do NOT modify AGENTS.md

---

## Verification Strategy

- **Read-only verification**: grep each file before and after to confirm changes
- No tests needed (documentation only)

---

## TODOs

- [ ] 1. **Fix QA_GAUNTLET.md §Pass 2 — remove stale turret.c duplicates from tribal list**

  **What to do**:
  - Read `docs/QA_GAUNTLET.md` to find the Pass 2 "Known tribal duplicates" list
  - Remove any entries that reference `turret.c` for functions now accessed via `::` exports
  - Add a note: "After the load chain fix, turret.c no longer redefines these functions — they're accessed via getroottable() exports from gnome_turret_trigger.c. Only check for divergence between lib_utils.c and gnome_turret_trigger.c."
  - Verify: grep turret.c for any claimed duplicate function definitions — expect zero matches

  **Commit**: YES
  - Message: `docs(qa): remove stale turret.c entries from tribal duplicates list`
  - Files: `docs/QA_GAUNTLET.md`

- [ ] 2. **Fix CHANGELOG.md — add load chain fix to [Unreleased]**

  **What to do**:
  - Read `CHANGELOG.md` to find the `## [Unreleased]` and `## [2.0.0]` sections
  - Under `## [Unreleased]` → `### Fixed`, add: `- Load chain: `IncludeScript("sm_utilities", getroottable())` added to `gnome_turret_trigger.c:973`, wiring sm_utilities → lib_utils + turret into the runtime load path. Per-survivor globals deduplicated from turret.c.`
  - In the `## [2.0.0]` → `### Notes` section, update or remove the "Known issue" paragraph about the load chain being unreachable

  **Commit**: YES
  - Message: `docs(changelog): document load chain fix in [Unreleased]`
  - Files: `CHANGELOG.md`

- [ ] 3. **QA verification — confirm changes match source state**

  **What to do**:
  - Read both updated files end-to-end
  - grep turret.c for any function name still listed as a "duplicate" in QA_GAUNTLET.md — expect zero definition matches
  - Read gnome_turret_trigger.c:973 — confirm IncludeScript is correctly described in CHANGELOG.md
  - Verify no stale "not reachable" language remains in CHANGELOG.md

  **Commit**: YES (groups with tasks 1-2 if no changes needed)
  - Message: `docs: verify downstream doc fixes match source state`
  - Files: `CHANGELOG.md`, `docs/QA_GAUNTLET.md`

---

## Final Verification Wave

- [ ] F1. **Plan Compliance Audit** — `oracle`
  Read both updated files. Verify every claim against source. Check: no stale orphan language remains in CHANGELOG.md, QA_GAUNTLET.md Pass 2 no longer flags non-existent turret.c duplicates.
  Output: `Claims [N/N verified] | Stale content [CLEAN/N issues] | VERDICT: APPROVE/REJECT`

---

## Commit Strategy

- **1-2**: Grouped commit — `docs: fix stale downstream docs to match fixed load chain`
- **3**: Included in same commit if no further changes needed
