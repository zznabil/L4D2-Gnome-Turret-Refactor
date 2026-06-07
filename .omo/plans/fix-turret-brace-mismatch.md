# Plan: Fix turret.c Brace Mismatch — 1 Extra `}`

## TL;DR

> **Quick Summary**: turret.nut has 224 `}` vs 223 `{` — one extra closing brace. Previously hidden because turret.nut was never loaded (orphan bug). Now that the IncludeScript chain works, L4D2's Squirrel parser rejects the file at line 1159 with "error expression expected." Find and remove the extra `}`.

> **Deliverables**: Fixed turret.c with balanced braces (223 `{` = 223 `}`)

> **Estimated Effort**: Short
> **Parallel Execution**: NO — sequential investigation
> **Critical Path**: Find → Fix → Verify → Publish → Test

---

## Context

### Runtime Error

```
scripts/vscripts/turret.nut line = (1159) column = (2) : error expression expected
```

The error cascades:
```
turret.nut:1159 syntax error
  → IncludeScript("turret") fails (sm_utilities.nut:1566)
    → IncludeScript("sm_utilities") fails (gnome_turret_trigger.nut:973)
```

### Root Cause
- `turret.c`/`turret.nut`: **223 `{`** vs **224 `}`** — 1 unmatched close brace
- `.c` and `.nut` are identical (verified), so the issue is in source, not a publish artifact
- The extra `}` is at the end of `class CTurret` (line 1159), causing the parser to see a stray closing brace after the class body has already been fully closed
- This was likely pre-existing but never surfaced because turret.nut was orphaned (not loaded at runtime)
- Now that the IncludeScript chain fix makes turret.nut load, the syntax error is exposed

---

## Work Objectives

### Core Objective
Find and remove the unmatched closing brace in turret.c so the file parses correctly in L4D2's Squirrel runtime.

### Must Have
- Brace count balanced: 223 `{` = 223 `}`
- turret.nut loads without syntax errors in L4D2
- No change to logic — only remove the extra brace

### Must NOT Have
- Do NOT change any function logic or variable assignment
- Do NOT run publish.bat without running nut_to_c + c_to_nut first
- Do NOT modify turret.nut directly (edit .c only)

---

## Verification Strategy

- Read: turret.c end-to-end — trace brace nesting to find the unmatched `}`
- Bash: `Select-String -Pattern '\{' | Measure-Object` vs `Select-String -Pattern '\}' | Measure-Object` — confirm balanced after fix
- Publish + user test in L4D2

---

## TODOs

- [x] 1. **Find the extra `}` — trace brace nesting in turret.c**

  **What to do**:
  - Read the full turret.c (1214 lines)
  - Starting from `class CTurret {` at line 7, trace every `{` and `}` using a stack
  - Pinpoint the exact line where the stack underflows (extra close)
  - Also scan for dead code: the `break;` at line 1141 has unreachable `if` statement at line 1142 immediately after — this may indicate a structural problem (missing `case`/`default` label, or the code at 1142-1152 was meant to be in a different block)
  - Look at lines 1130-1152 carefully — this is the closing cascade area with unreachable code patterns

  **Commit**: YES
  - Message: `debug(turret): identify location of extra closing brace`
  - Files: N/A (investigation only)

- [x] 2. **Fix the brace mismatch — remove or relocate the extra `}`**

  **What to do**:
  - Remove the identified unmatched `}`
  - If the issue is structural (code at 1142-1152 is dead after `break;` at 1141), fix the control flow:
    - Option A: Remove the dead `if` block (lines 1142-1152) if it's truly unreachable duplicate code
    - Option B: Add a missing `case`/`default` label to make it reachable if it's a distinct handler branch
  - Verify brace count: `{` must equal `}`
  - Save to turret.c only (NOT turret.nut)

  **Commit**: YES
  - Message: `fix(turret): remove unmatched closing brace, fix dead code after break`

- [x] 3. **Publish and verify**

  **What to do**:
  - Run `tools\nut_to_c.bat` (ensure .c view current)
  - Run `tools\c_to_nut.bat` (restore .nut)
  - Run `tools\publish.bat` (overwrite .nut from .c)
  - Verify turret.nut has balanced braces: `Select-String '\{' | Measure-Object` and `Select-String '\}' | Measure-Object`
  - Verify .c and .nut remain identical
  - Run `serena_get_symbols_overview` on turret.c to confirm parse-ability
  - Optional: Run `tools\build_vpk.bat` to produce new .vpk for user testing

  **Commit**: YES
  - Message: `build: publish fixed turret.nut with balanced braces`

---

## Final Verification Wave

- [x] F1. **Brace Balance Check** — run bash command
  Verify turret.nut has equal `{` and `}` counts after publish.
  Output: `Braces: {N open / N close} | Balanced: YES/NO`

- [x] F2. **Serena Parse Pass** — `serena_get_symbols_overview`
  Run on turret.c — must return valid symbols without error.
  Output: `Symbols: [count] | VERDICT: PASS/FAIL`

- [~] F3. **User Test** — user runs in L4D2
  User drops the rebuilt .vpk into L4D2 addons/ and starts a map.
  Expected: no console errors, turret mod loads successfully.
  Output: `Console errors: [N] | VERDICT: PASS/FAIL`

---

## Commit Strategy

- **1**: `debug(turret): identify location of extra closing brace`
- **2**: `fix(turret): remove unmatched closing brace`
- **3**: `build: publish fixed turret.nut with balanced braces`
