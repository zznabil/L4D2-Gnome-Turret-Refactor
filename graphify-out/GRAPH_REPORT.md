# Graph Report - turret  (2026-06-06)

## Corpus Check
- 35 files · ~46,159 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 653 nodes · 993 edges · 53 communities (52 shown, 1 thin omitted)
- Extraction: 95% EXTRACTED · 5% INFERRED · 0% AMBIGUOUS · INFERRED: 47 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]
- [[_COMMUNITY_Community 8|Community 8]]
- [[_COMMUNITY_Community 9|Community 9]]
- [[_COMMUNITY_Community 10|Community 10]]
- [[_COMMUNITY_Community 11|Community 11]]
- [[_COMMUNITY_Community 12|Community 12]]
- [[_COMMUNITY_Community 13|Community 13]]
- [[_COMMUNITY_Community 14|Community 14]]
- [[_COMMUNITY_Community 15|Community 15]]
- [[_COMMUNITY_Community 16|Community 16]]
- [[_COMMUNITY_Community 17|Community 17]]
- [[_COMMUNITY_Community 18|Community 18]]
- [[_COMMUNITY_Community 19|Community 19]]
- [[_COMMUNITY_Community 20|Community 20]]
- [[_COMMUNITY_Community 21|Community 21]]
- [[_COMMUNITY_Community 22|Community 22]]
- [[_COMMUNITY_Community 23|Community 23]]
- [[_COMMUNITY_Community 24|Community 24]]
- [[_COMMUNITY_Community 25|Community 25]]
- [[_COMMUNITY_Community 26|Community 26]]
- [[_COMMUNITY_Community 27|Community 27]]
- [[_COMMUNITY_Community 28|Community 28]]
- [[_COMMUNITY_Community 29|Community 29]]
- [[_COMMUNITY_Community 30|Community 30]]
- [[_COMMUNITY_Community 31|Community 31]]
- [[_COMMUNITY_Community 32|Community 32]]
- [[_COMMUNITY_Community 33|Community 33]]
- [[_COMMUNITY_Community 34|Community 34]]
- [[_COMMUNITY_Community 42|Community 42]]
- [[_COMMUNITY_Community 43|Community 43]]
- [[_COMMUNITY_Community 44|Community 44]]
- [[_COMMUNITY_Community 45|Community 45]]
- [[_COMMUNITY_Community 46|Community 46]]
- [[_COMMUNITY_Community 47|Community 47]]
- [[_COMMUNITY_Community 48|Community 48]]

## God Nodes (most connected - your core abstractions)
1. `function` - 81 edges
2. `function` - 25 edges
3. `function` - 21 edges
4. `function` - 21 edges
5. `vector` - 20 edges
6. `Turret_Think()` - 16 edges
7. `todo:1` - 14 edges
8. `todo:3` - 14 edges
9. `PlaceTurret()` - 14 edges
10. `update-agents-md-7a37d206` - 13 edges

## Surprising Connections (you probably didn't know these)
- `PlaceTurret()` --calls--> `CfgFileCheck()`  [INFERRED]
  scripts/vscripts/turret.c → scripts/vscripts/gnome_turret_trigger.c
- `PlaceTurret()` --calls--> `GenerateGnomeTurretCfgFile()`  [INFERRED]
  scripts/vscripts/turret.c → scripts/vscripts/gnome_turret_trigger.c
- `OnUsePress()` --calls--> `GenerateGnomeVirtualInventory()`  [INFERRED]
  scripts/vscripts/turret.c → scripts/vscripts/gnome_turret_trigger.c
- `Turret_Think()` --calls--> `GenerateGnomeVirtualInventory()`  [INFERRED]
  scripts/vscripts/turret.c → scripts/vscripts/gnome_turret_trigger.c
- `PlaceTurret()` --calls--> `LoadSpecificConfigFile()`  [INFERRED]
  scripts/vscripts/turret.c → scripts/vscripts/gnome_turret_trigger.c

## Import Cycles
- None detected.

## Communities (53 total, 1 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.05
Nodes (59): baseTable, callback, classname, clearoutTable, delimiter, destname, destscope, entity (+51 more)

### Community 1 - "Community 1"
Cohesion: 0.15
Nodes (13): task_sessions, todo:1, agent, category, elapsed_ms, ended_at, session_id, started_at (+5 more)

### Community 2 - "Community 2"
Cohesion: 0.10
Nodes (43): aAmmo, fTime, hEntity, hIgnoreEntity, hMachineGun, hTarget, hTracerEntity, hWeapon (+35 more)

### Community 3 - "Community 3"
Cohesion: 0.17
Nodes (11): active_plan, active_work_id, agent, elapsed_ms, ended_at, plan_name, schema_version, session_ids (+3 more)

### Community 4 - "Community 4"
Cohesion: 0.15
Nodes (35): ammo, certainsurv, customhint, customicon, duration, event, filename, itemclass (+27 more)

### Community 5 - "Community 5"
Cohesion: 0.08
Nodes (25): 1. Why this exists, 2. Steady-state: hybrid mode (recommended), 3. Activating Serena (once per session), 4.1 Orient first: `get_symbols_overview`, 4.2 Drill in: `find_symbol`, 4.3 Cross-file references: `find_referencing_symbols`, 4.4 Text/regex search: `search_for_pattern`, 4.5 Diagnostics: `get_diagnostics_for_file` (+17 more)

### Community 6 - "Community 6"
Cohesion: 0.08
Nodes (25): Agent Dispatch Summary, Commit Strategy, Concrete Deliverables, Context, Core Objective, Definition of Done, Dependency Matrix, Execution Strategy (+17 more)

### Community 7 - "Community 7"
Cohesion: 0.10
Nodes (24): bitmask, convar, sCommand, function, CollectAlivePlayers(), CollectAliveSurvivors(), CollectPlayers(), GetClassType() (+16 more)

### Community 8 - "Community 8"
Cohesion: 0.10
Nodes (20): 1. Summary, 2.1 What's already in place, 2.2 File roles (corrected), 2.3 Critical bug found in the mod load chain, 2.4 Stale descriptions in existing docs, 2. Current State Analysis (deep dive, re-verified this turn), 3.1 New docs, 3.2 New scripts (+12 more)

### Community 9 - "Community 9"
Cohesion: 0.10
Nodes (20): Concrete Deliverables, Context, Core Objective, Execution Strategy, Final Checklist, Final Verification Wave, Interview Summary, Metis Review (+12 more)

### Community 10 - "Community 10"
Cohesion: 0.10
Nodes (19): Additional References, Agent-Specific Instructions, Build, Test, and Development Commands, Clangd Error Classification (95% Noise), Coding Style & Naming Conventions, Edit → Verify → Publish → Build Cycle, File Map, Load Chain (+11 more)

### Community 11 - "Community 11"
Cohesion: 0.11
Nodes (20): button, class, __instance, hPlayer, sMsg, sName, ButtonsListener_Think(), CButtonListener() (+12 more)

### Community 12 - "Community 12"
Cohesion: 0.10
Nodes (19): 1. Roles, 2.1 Phase 0 — Session start, 2.2 Phase 1 — Edit (`.c` only), 2.3 Phase 2 — QA gauntlet, 2.4 Phase 3 — Publish, 2.5 Phase 4 — Build, 2.6 Phase 5 — User test, 2.7 Phase 6 — Feedback (+11 more)

### Community 13 - "Community 13"
Cohesion: 0.11
Nodes (18): 1. Summary, 2.1 Project Layout, 2.2 Load Order & Dependencies, 2.3 Round Lifecycle, 2.4 Per-Survivor Tribal State (drift risk), 2.5 Known Bug (worth flagging for Serena to find), 2.6 Conventions & Style, 2. Deep Dive — Tribal Knowledge, Practices, Logic Flow (+10 more)

### Community 14 - "Community 14"
Cohesion: 0.33
Nodes (10): a1, a2, bShortWay, bSlerp, q1, q2, t, OrientationLerp() (+2 more)

### Community 15 - "Community 15"
Cohesion: 0.12
Nodes (15): CHECK 1 — Load Chain Claims ✅, CHECK 2 — Per-Survivor Globals Removed from turret.c ✅, CHECK 3 — TurretDataSaveTimer at turret.c Top ✅, CHECK 4 — Tool Gotcha Claims ✅, CHECK 5 — .omo Directory Structure ✅, CHECK 6 — No opencode.json ✅, CHECK 7 — Serena Parse Pass ✅, CHECK 8 — Stale Content Scrub ✅ (+7 more)

### Community 16 - "Community 16"
Cohesion: 0.23
Nodes (12): eAngles, q, vector, Forward(), Forward2D(), GetDistanceToGround(), GetPositionToGround(), Left() (+4 more)

### Community 17 - "Community 17"
Cohesion: 0.13
Nodes (14): Commit Strategy, Concrete Deliverables, Context, Core Objective, Final Verification Wave, Must Have, Must NOT Have, Original Request (+6 more)

### Community 18 - "Community 18"
Cohesion: 0.14
Nodes (13): Commit Strategy, Context, Core Objective, Final Verification Wave, Must Have, Must NOT Have, Plan: Fix turret.c Brace Mismatch — 1 Extra `}`, Root Cause (+5 more)

### Community 19 - "Community 19"
Cohesion: 0.15
Nodes (13): max, min, Value, vector_max, vector_min, Between(), GetCurrentValue(), IsNaN() (+5 more)

### Community 20 - "Community 20"
Cohesion: 0.20
Nodes (9): [2.0.0] - 2025-XX-XX, Added, Added, Changed, Changelog, Fixed, Notes, Removed (+1 more)

### Community 21 - "Community 21"
Cohesion: 0.22
Nodes (8): 1. Mod load, 2. Core feature, 3. Stability, 4. Balance, 5. Polish, 6. Next, After the user answers, In-Game Feedback Template

### Community 22 - "Community 22"
Cohesion: 0.22
Nodes (8): Completed: 2026-06-05, Learnings — Fix Orphan Load Chain, Phase 2: Tribal Deduplication (turret.c), Preserved (turret-only), Remaining references, Removed (489 lines deleted, 1639 → 1154 lines), Summary, Verification

### Community 23 - "Community 23"
Cohesion: 0.39
Nodes (9): flRefireTime, sFunction, IsFunctionExist(), IsLoopFunctionRegistered(), IsOnTickFunctionRegistered(), RegisterLoopFunction(), RegisterOnTickFunction(), RemoveLoopFunction() (+1 more)

### Community 24 - "Community 24"
Cohesion: 0.29
Nodes (8): flDelay, hFunction, tParams, CreateTimer(), CTimer(), OnPlayerSay(), OnRoundStart(), RunNextTickFunction()

### Community 25 - "Community 25"
Cohesion: 0.25
Nodes (7): Final Verification Wave, Phase 1: Audit Conflicts, Phase 2: Resolve Conflicts, Phase 3: Wire the Load Chain, Phase 4: Verify, Plan: Fix the Orphan Load Chain, TODOs

### Community 26 - "Community 26"
Cohesion: 0.25
Nodes (7): Files, Going back to a clean source state, Round-trip example, Safety, Squirrel ↔ C Rename Workaround for Serena Tools, Workflow (full dev cycle), Workflow (rename scripts only)

### Community 27 - "Community 27"
Cohesion: 0.52
Nodes (7): key, var, GetScriptScope(), GetScriptScopeVar(), KeyInScriptScope(), RemoveScriptScopeKey(), SetScriptScopeVar()

### Community 28 - "Community 28"
Cohesion: 0.43
Nodes (7): n, a, b, Clamp(), Lerp(), Max(), Min()

### Community 29 - "Community 29"
Cohesion: 0.29
Nodes (6): state, updatedAt, sessionID, sources, background-task, updatedAt

### Community 30 - "Community 30"
Cohesion: 0.33
Nodes (5): Expected output on the current tree, Pass 1 — Parse, Pass 2 — Drift, Pass 3 — Reachability, QA Gauntlet: Triple Fact-Check Checklist

### Community 31 - "Community 31"
Cohesion: 0.33
Nodes (6): FLerp(), x, x_end, x_start, y_end, y_start

### Community 32 - "Community 32"
Cohesion: 0.40
Nodes (5): flAngle, vecDirection, NormalizeAngle(), QuaternionRotation(), VectorToQAngle2()

### Community 33 - "Community 33"
Cohesion: 0.11
Nodes (17): Current Code Structure, Existing Particle System Usage, Files to Modify, Implementation Details, Implementation Steps, Laser Attachment Point, Laser Configuration, Notes (+9 more)

### Community 42 - "Community 42"
Cohesion: 0.17
Nodes (12): agent, elapsed_ms, ended_at, session_id, started_at, status, task_key, task_label (+4 more)

### Community 43 - "Community 43"
Cohesion: 0.17
Nodes (12): active_plan, agent, elapsed_ms, ended_at, plan_name, session_ids, started_at, status (+4 more)

### Community 44 - "Community 44"
Cohesion: 0.17
Nodes (12): todo:2, agent, category, elapsed_ms, ended_at, session_id, started_at, status (+4 more)

### Community 45 - "Community 45"
Cohesion: 0.17
Nodes (12): todo:3, agent, category, elapsed_ms, ended_at, session_id, started_at, status (+4 more)

### Community 46 - "Community 46"
Cohesion: 0.17
Nodes (12): active_plan, agent, elapsed_ms, ended_at, plan_name, session_ids, started_at, status (+4 more)

### Community 47 - "Community 47"
Cohesion: 0.36
Nodes (10): vector_a, vector_b, Cross(), Dot(), GetAngleBetweenVectors(), GetAngleBetweenVectors2(), Normalize(), Project() (+2 more)

### Community 48 - "Community 48"
Cohesion: 0.50
Nodes (4): session_origins, session_origins, opencode:ses_1679e7818ffeaFSuaC82lG82qx, session_origins

## Knowledge Gaps
- **343 isolated node(s):** `schema_version`, `active_work_id`, `work_id`, `active_plan`, `plan_name` (+338 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `vector` connect `Community 16` to `Community 0`, `Community 2`, `Community 19`, `Community 47`?**
  _High betweenness centrality (0.057) - this node is a cross-community bridge._
- **Why does `function` connect `Community 7` to `Community 32`, `Community 2`, `Community 11`, `Community 14`, `Community 47`, `Community 16`, `Community 19`, `Community 23`, `Community 24`, `Community 27`, `Community 28`, `Community 31`?**
  _High betweenness centrality (0.041) - this node is a cross-community bridge._
- **Why does `Turret_Think()` connect `Community 2` to `Community 16`, `Community 19`, `Community 11`, `Community 4`?**
  _High betweenness centrality (0.029) - this node is a cross-community bridge._
- **Are the 16 inferred relationships involving `vector` (e.g. with `Cross()` and `Forward()`) actually correct?**
  _`vector` has 16 INFERRED edges - model-reasoned connections that need verification._
- **What connects `schema_version`, `active_work_id`, `work_id` to the rest of the system?**
  _343 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.05423728813559322 - nodes in this community are weakly interconnected._
- **Should `Community 2` be split into smaller, more focused modules?**
  _Cohesion score 0.10465116279069768 - nodes in this community are weakly interconnected._