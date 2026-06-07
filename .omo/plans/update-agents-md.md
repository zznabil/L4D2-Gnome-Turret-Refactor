# Plan: Update AGENTS.md for Current Code State + OpenCode SDLC

## TL;DR

> **Quick Summary**: Update the stale AGENTS.md to reflect the fixed load chain (orphan bug resolved in source), add OpenCode workflow context for autonomous SDLC takeover, and document critical tool behavior gotchas that agents would otherwise discover through trial and error.

> **Deliverables**:
> - Updated `AGENTS.md` with corrected orphan status, OpenCode context, and tool gotchas

> **Estimated Effort**: Quick
> **Parallel Execution**: NO — sequential (single file edit)
> **Critical Path**: Task 1 → Task 2 → Task 3

---

## Context

### Original Request
User requested: "Create or update AGENTS.md for this repository" with the focus "deep dive ulw to take over development SDLC." The user selected "Include OpenCode context" for scope.

### Interview Summary
**Key Discussions**:
- User chose to include OpenCode-specific workflow context (.omo/ directory, boulder tracking, ULW continuation)
- User answered "idk" about whether the orphan fix was published/built and works at runtime

**Critical Finding (Metis + Oracle verified)**:
- The `IncludeScript("sm_utilities", getroottable())` at `gnome_turret_trigger.c:973` IS present in both .c and .nut files
- Per-survivor globals were removed from `turret.c` (only `TurretDataSaveTimer` remains)
- Function exports via `::` scope operator exist at lines 975-987
- The `boulder.json` records `fix-orphan-load-chain` as `status: "completed"`
- **The AGENTS.md is STALE** — it claims an "open bug" that has been resolved in source code

**Research Findings**:
- All .c and .nut files are byte-identical (fix is published to both)
- Load chain: `mapspawn_addon → gnome_turret_trigger → sm_utilities → lib_utils + turret`
- No `opencode.json` exists in the repo
- `.omo/` directory contains `boulder.json` (work tracking), `plans/` (work plans), `run-continuation/` (session resumption)
- `dev_cycle.bat` pauses with `Read-Host "Type 'gauntlet passed' to continue"` — NOT agent-executable via bash
- `build_vpk.bat` auto-closes after 5-second countdown on success
- `build_vpk.ps1` cleans `dist/` before every build
- Config files write to game-relative paths, not project-relative

### Metis Review
**Identified Gaps** (addressed):
- AGENTS.md orphan bug claim is false — fix is in source → Replace section with accurate status
- `dev_cycle.bat` interactivity undocumented → Add to tool gotchas
- `.omo/` directory undocumented → New section needed
- Tribal duplication list may be stale after fix → Verify and update
- No conflict resolution rule for AGENTS.md vs boulder.json → Add guidance
- `::` scope operator not in "known clangd noise" list → Add

---

## Work Objectives

### Core Objective
Update AGENTS.md to accurately reflect the current codebase state and provide all context an agent needs for autonomous SDLC takeover via ULW loop.

### Concrete Deliverables
- Updated `AGENTS.md` at project root

### Definition of Done
- [ ] Orphan bug section replaced with accurate status reflecting code evidence
- [ ] FILE MAP shows all 5 files as ✓ LOADED
- [ ] WHAT NOT TO DO updated (all .c files are now editable)
- [ ] OpenCode workflow section added (.omo/, boulder.json, plans, run-continuation)
- [ ] Tool gotchas section added (dev_cycle.bat, build_vpk.bat, publish behavior)
- [ ] Every new claim verifiable by reading the referenced source file
- [ ] No contradiction between AGENTS.md and boulder.json state

### Must Have
- Accurate orphan/load-chain status reflecting the IncludeScript fix
- Correct FILE MAP with all files marked as loaded
- OpenCode workflow context (.omo directory structure)
- Tool behavior gotchas (dev_cycle interactivity, build_vpk auto-close)

### Must NOT Have (Guardrails)
- Do NOT change verified accurate sections without cause
- Do NOT add speculative claims not verifiable against source
- Do NOT remove tribal duplication note (still relevant even if turret.c duplicates reduced)
- Do NOT claim the fix "works" — note it's in source, runtime unverified
- Do NOT create new documentation files
- Do NOT modify tool scripts or source files

---

## Verification Strategy

### Test Decision
- **Infrastructure exists**: NO (no test runner, no CI)
- **Automated tests**: None (documentation-only task)
- **Framework**: N/A
- **Verification method**: Manual claim-by-claim verification against source files + Serena LSP

### QA Policy
Every claim in the updated AGENTS.md must be verifiable by reading or grepping the referenced source file.

---

## Execution Strategy

### Parallel Execution Waves

```
Wave 1 (Sequential - single file edit):
├── Task 1: Fix stale content (orphan section, file map, what not to do)
├── Task 2: Add new sections (OpenCode workflow, tool gotchas, squirrel notes)
└── Task 3: QA verification — verify every claim against source

Wave FINAL (After all tasks):
└── Task F1: Plan compliance audit (oracle) — verify claims against codebase
```

### Dependency Matrix

- **1**: — — 2
- **2**: 1 — 3
- **3**: 2 — F1

### Agent Dispatch Summary

- **Wave 1**: **1** - T1 → `quick`, T2 → `quick`, T3 → `unspecified-low`
- **FINAL**: **1** - F1 → `oracle`

---

## TODOs

- [x] 1. **Fix stale content: orphan section, file map, what not to do**

  **What to do**:
  - Replace the "⚠️ THE ORPHAN BUG — MOST CODE IS DEAD AT RUNTIME" section with a new section titled "⚠️ FORMER ORPHAN — NOW FIXED (code-level, runtime unverified)"
  - Document the current load chain: `mapspawn_addon → gnome_turret_trigger → IncludeScript("sm_utilities") → IncludeScript("lib_utils") + IncludeScript("turret")`
  - Note the IncludeScript is at line 973 of gnome_turret_trigger.c/.nut
  - Add a caveat: "The fix is in source code (verified 2026-06-05). Whether publish.bat + build_vpk.bat was run to deploy it is unconfirmed. If the mod doesn't work at runtime, run `tools\publish.bat` then `tools\build_vpk.bat`."
  - Update FILE MAP: change `sm_utilities.c`, `lib_utils.c`, `turret.c` from "✗ ORPHAN" to "✓" with load chain description
  - Update WHAT NOT TO DO item #2: remove "DO NOT edit sm_utilities.c/lib_utils.c/turret.c expecting in-game results" — all files are now editable and loaded
  - Keep the tribal duplication section but add note: "After the orphan fix, turret.c no longer redefines the per-survivor globals or shared functions. It accesses them via getroottable() exports from gnome_turret_trigger.c."

  **Must NOT do**:
  - Do NOT claim the fix "works at runtime" — only state it's in source
  - Do NOT remove the tribal duplication section entirely
  - Do NOT change other sections that aren't stale

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Single file, well-understood changes, no creative work required
  - **Skills**: None required

  **Parallelization**:
  - **Can Run In Parallel**: NO
  - **Parallel Group**: Sequential (Wave 1)
  - **Blocks**: Task 2
  - **Blocked By**: None

  **References**:
  - `scripts/vscripts/gnome_turret_trigger.c:973` — IncludeScript("sm_utilities", getroottable()) proving load chain is fixed
  - `scripts/vscripts/gnome_turret_trigger.c:975-1006` — `::` export block for shared functions and globals
  - `scripts/vscripts/turret.c:1-7` — Only TurretDataSaveTimer remains at top; per-survivor globals removed
  - `scripts/vscripts/sm_utilities.c:1565-1566` — IncludeScript("lib_utils") + IncludeScript("turret") confirming chain is complete
  - `.omo/boulder.json` — fix-orphan-load-chain work marked "completed" (matches code state)
  - Current `AGENTS.md:11-21` — The stale orphan bug section to be replaced

  **Acceptance Criteria**:
  - [ ] AGENTS.md orphan section replaced with "FORMER ORPHAN — NOW FIXED" content
  - [ ] FILE MAP shows all 5 .c files as loaded
  - [ ] WHAT NOT TO DO item #2 updated or removed
  - [ ] New load chain diagram is accurate (verify by reading each IncludeScript line)

  **QA Scenarios**:

  ```
  Scenario: Claims match source code
    Tool: Bash (grep)
    Preconditions: AGENTS.md saved with changes
    Steps:
      1. grep "IncludeScript" scripts/vscripts/gnome_turret_trigger.c — expect line 973 with "sm_utilities"
      2. grep "IncludeScript" scripts/vscripts/sm_utilities.c — expect lines 1565-1566 with "lib_utils" and "turret"
      3. grep "GnomeTurretNick\|GnomeTurretDamage\|GnomeTurretAmmo" scripts/vscripts/turret.c — expect NO top-level definitions (only runtime references in function bodies)
      4. Read AGENTS.md FILE MAP section — expect all files marked as ✓ or loaded
    Expected Result: All grep results match claims made in updated AGENTS.md
    Failure Indicators: IncludeScript NOT found at stated line; globals still defined at top of turret.c; FILE MAP still shows orphans
    Evidence: .omo/evidence/task-1-claims-verified.txt
  ```

  **Commit**: YES
  - Message: `docs(agents): fix stale orphan bug status, update file map to reflect fixed load chain`
  - Files: `AGENTS.md`

- [x] 2. **Add new sections: OpenCode workflow, tool gotchas, squirrel notes**

  **What to do**:
  - Add a new section "## OPENCODE WORKFLOW" covering:
    - `.omo/` directory structure: `boulder.json` (active work tracking), `plans/` (work plans), `run-continuation/` (session resumption), `notepads/` (working memory)
    - How to read `boulder.json` to find active plan and work state
    - Warning: AGENTS.md vs boulder.json conflict resolution rule — "boulder.json is factual history of completed work. AGENTS.md is the current state. When they conflict, AGENTS.md is the intended target. Flag discrepancies to user."
    - No `opencode.json` exists (and should not be created)
  - Add a new section "## TOOL GOTCHAS" covering:
    - `dev_cycle.bat` is interactive: pauses with `Read-Host "Type 'gauntlet passed' to continue"`. **DO NOT run via bash** — it will hang indefinitely. Run individual scripts: `nut_to_c.ps1` → QA gauntlet → `publish.ps1` → `build_vpk.ps1`
    - `build_vpk.bat` auto-closes after 5-second countdown on success. Call `build_vpk.ps1` directly instead.
    - `build_vpk.ps1` cleans `dist/` on every run (deletes all contents before producing new .vpk)
    - `c_to_nut.ps1` silently skips existing .nut files — does not compare content or timestamps. If .nut was hand-edited, c_to_nut preserves the hand-edited version (not the .c version). Use `publish.ps1` to force overwrite.
    - `publish.ps1` requires .c files to exist. If only .nut files are present (never ran nut_to_c), publish.ps1 exits with error.
    - Config file paths (`gnome turret/gnome turret.txt`) are relative to the L4D2 game root, NOT the project root or vscripts directory.
  - Expand "CLANGD ERRORS" section with one more known-noise item: `::` scope operator (used for root-table exports like `::LoadSpecificConfigFile <- LoadSpecificConfigFile`)
  - Add to "ADDITIONAL REFERENCES": `script_reload` console command for faster in-game testing without rebuilding .vpk

  **Must NOT do**:
  - Do NOT create new files — all content goes into AGENTS.md
  - Do NOT add long tutorials or generic advice
  - Do NOT claim dev_cycle.bat can be fixed — just document the gotcha

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Adding documented sections, no creative work, all content already researched
  - **Skills**: None required

  **Parallelization**:
  - **Can Run In Parallel**: NO
  - **Parallel Group**: Sequential (Wave 1)
  - **Blocks**: Task 3
  - **Blocked By**: Task 1

  **References**:
  - `.omo/boulder.json` — reference for .omo directory structure documentation
  - `.omo/plans/` — list plan files to reference
  - `.omo/run-continuation/` — verify session continuation files exist
  - `tools/dev_cycle.ps1:52-57` — Read-Host pause proving interactivity
  - `tools/build_vpk.bat:25-28` — 5-second countdown proving auto-close
  - `tools/build_vpk.ps1:21` — `Remove-Item -Path "$DistDir\*" -Recurse` proving dist cleanup
  - `tools/c_to_nut.ps1:23-28` — Skip-if-exists logic
  - `tools/publish.ps1:16-19` — Requires .c files to exist
  - `scripts/vscripts/gnome_turret_trigger.c:976` — `::LoadSpecificConfigFile` example of `::` scope operator

  **Acceptance Criteria**:
  - [ ] "OPENCODE WORKFLOW" section exists with .omo/ structure documented
  - [ ] "TOOL GOTCHAS" section exists with dev_cycle.bat and build_vpk.bat warnings
  - [ ] Conflict resolution rule (AGENTS.md vs boulder.json) documented
  - [ ] "No opencode.json exists" noted
  - [ ] `::` scope operator added to known clangd noise list
  - [ ] `script_reload` noted in additional references

  **QA Scenarios**:

  ```
  Scenario: Tool gotchas are accurate
    Tool: Bash (grep)
    Preconditions: AGENTS.md saved with new sections
    Steps:
      1. grep "Read-Host" tools/dev_cycle.ps1 — expect "Type 'gauntlet passed' to continue" confirming interactivity
      2. grep "Remove-Item.*DistDir" tools/build_vpk.ps1 — expect dist cleanup command
      3. grep "skip (exists)" tools/c_to_nut.ps1 — expect skip logic
      4. Read AGENTS.md TOOL GOTCHAS — expect dev_cycle.bat warning matches Read-Host behavior
    Expected Result: Every tool gotcha claim in AGENTS.md verified by reading the source script
    Evidence: .omo/evidence/task-2-tool-gotchas-verified.txt
  ```

  **Commit**: YES (groups with Task 1)
  - Message: `docs(agents): add OpenCode workflow, tool gotchas, squirrel notes`
  - Files: `AGENTS.md`

- [x] 3. **QA verification — verify every claim against source files**

  **What to do**:
  - Read the completed AGENTS.md end-to-end
  - For EVERY factual claim (line numbers, file states, tool behaviors), grep or read the referenced source to confirm
  - Verify the load chain diagram: `mapspawn_addon → gnome_turret_trigger → sm_utilities → lib_utils + turret` by reading each IncludeScript/vscripts line
  - Verify the FILE MAP load status matches actual IncludeScript chain
  - Verify no contradiction between AGENTS.md claims and boulder.json state
  - Run Serena `get_symbols_overview` on each .c file to confirm parse-ability (simulates Pass 1)
  - Check for any remaining stale claims or formatting issues

  **Must NOT do**:
  - Do NOT make edits unless a factual error is found (then fix and note)
  - Do NOT run publish.bat or build_vpk.bat — read-only verification only

  **Recommended Agent Profile**:
  - **Category**: `unspecified-low`
    - Reason: Read-only verification task, systematic claim checking, no creative work
  - **Skills**: None required

  **Parallelization**:
  - **Can Run In Parallel**: NO
  - **Parallel Group**: Sequential (Wave 1)
  - **Blocks**: F1
  - **Blocked By**: Task 2

  **References**:
  - `AGENTS.md` (updated) — the file to verify
  - `scripts/vscripts/gnome_turret_trigger.c:973` — IncludeScript verification
  - `scripts/vscripts/sm_utilities.c:1565-1566` — IncludeScript chain verification
  - `scripts/vscripts/turret.c:1-7` — Global deduplication verification
  - `.omo/boulder.json` — Work state verification
  - `tools/dev_cycle.ps1:52-57` — Interactivity verification
  - `tools/build_vpk.ps1:1-3` — vpk.exe path verification

  **Acceptance Criteria**:
  - [ ] Every factual claim in AGENTS.md verified against source
  - [ ] Zero contradictions between AGENTS.md and source files
  - [ ] Serena parse pass: `get_symbols_overview` returns symbols for all 5 .c files
  - [ ] No stale content remains

  **QA Scenarios**:

  ```
  Scenario: Serena parse pass (all .c files parseable)
    Tool: serena_get_symbols_overview
    Preconditions: Serena project activated (serena_activate_project)
    Steps:
      1. serena_get_symbols_overview("scripts/vscripts/mapspawn_addon.c", depth=1) — expect no error
      2. serena_get_symbols_overview("scripts/vscripts/gnome_turret_trigger.c", depth=1) — expect symbols
      3. serena_get_symbols_overview("scripts/vscripts/sm_utilities.c", depth=1) — expect symbols
      4. serena_get_symbols_overview("scripts/vscripts/lib_utils.c", depth=1) — expect symbols
      5. serena_get_symbols_overview("scripts/vscripts/turret.c", depth=1) — expect symbols
    Expected Result: All 5 calls return symbol data without errors
    Failure Indicators: Any call returns empty or error (file truncated/corrupted)
    Evidence: .omo/evidence/task-3-parse-pass.txt
  ```

  **Commit**: YES (groups with Tasks 1-2)
  - Message: `docs(agents): final verification pass, no changes needed`
  - Files: `AGENTS.md`

---

## Final Verification Wave

- [x] F1. **Plan Compliance Audit** — `oracle`
  Read the updated AGENTS.md end-to-end. For each factual claim (line numbers, file states, load chain), grep/read the referenced source file and confirm the claim is accurate. Check: no stale orphan bug language remains, FILE MAP shows correct load status, tool gotchas are accurate, OpenCode workflow section correctly describes .omo/ structure. Verify no contradiction with boulder.json state.
  Output: `Claims [N/N verified] | Stale content [CLEAN/N issues] | VERDICT: APPROVE/REJECT`

- [x] F2. **Security/Correctness Audit** — `oracle`
  N/A — documentation-only change, no code surface to audit.
  Output: `VERDICT: N/A`

- [x] F3. **QA / Usability Check** — `oracle`
  N/A — no runtime behavior change. Skip.
  Output: `VERDICT: N/A`

- [x] F4. **Integration / Cross-Reference Check** — `oracle`
  N/A — single-file change with no dependency impact. Skip.
  Output: `VERDICT: N/A`

---

## Commit Strategy

- **1-3**: `docs(agents): update for fixed load chain, add OpenCode context and tool gotchas` — `AGENTS.md`

---

## Success Criteria

### Verification Commands
```bash
# Verify IncludeScript is in gnome_turret_trigger.c
grep "IncludeScript.*sm_utilities" scripts/vscripts/gnome_turret_trigger.c
# Expected: IncludeScript("sm_utilities", getroottable());

# Verify no orphan bug language remains
grep -i "orphan\|dead.*runtime" AGENTS.md
# Expected: Only FORMER ORPHAN section (no claims of active bug)

# Verify FILE MAP shows correct status
grep -A 6 "FILE MAP" AGENTS.md
# Expected: All files show ✓ or loaded
```

### Final Checklist
- [ ] Orphan bug section replaced with accurate content
- [ ] FILE MAP updated (all files loaded)
- [ ] OpenCode workflow section present
- [ ] Tool gotchas section present
- [ ] All factual claims verified against source
- [ ] Zero contradictions with boulder.json
- [ ] All "Must NOT Have" guardrails respected
