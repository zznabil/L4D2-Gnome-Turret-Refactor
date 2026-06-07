# In-Game Feedback Template

After the user runs the in-game build (Phase 5 in
[SDLC_AND_QA.md](SDLC_AND_QA.md) → Phase 6), the agent asks these six
questions. The user's answers drive the next cycle and the changelog.

The agent should ask the questions as a numbered list, in this order,
and wait for the user's reply before doing anything else.

---

## 1. Mod load

> Did the mod load without console errors?

- If **yes**: move on.
- If **no**: ask the user to open the L4D2 console (~ key) and paste
  any red text. Note the first error line — that's almost always the
  root cause; everything below it is fallout.

## 2. Core feature

> Does the new behavior work as described in the changelog entry?

Expected answer: **yes** / **no** / **partial** + a one-sentence
description. If "partial" or "no", ask the user to describe what
happened vs. what they expected.

## 3. Stability

> Any crashes, freezes, or visual glitches?

- Crash to desktop: ask for the L4D2 crash dump timestamp / location
  and the last few console lines.
- Freeze: ask whether it was reproducible and what was happening
  in-game at the moment.
- Visual glitch: ask for a screenshot if possible.

## 4. Balance

> Are the numbers (damage, ammo, range, cooldown) where you want them?

This is the question that drives most iteration loops. The user almost
always has an opinion here. Capture it verbatim; it's a direct input to
the next Pass-1→3 cycle.

## 5. Polish

> Anything that feels off, even if you can't name it?

This is the "what's nagging you" question. Listen for things the user
isn't sure how to articulate — UI quirks, sound timing, feedback
clarity, etc. These become the polish backlog.

## 6. Next

> What would you like to see in the next iteration?

The user proposes the next change. The agent then re-enters Phase 1
(Edit) with that as the goal.

---

## After the user answers

- If every answer is positive, the agent offers to cut a release
  (Phase 7 in [SDLC_AND_QA.md](SDLC_AND_QA.md)).
- If any answer indicates a bug, the agent re-enters Phase 1 to fix.
- If the user has a new feature in mind, the agent writes it up as an
  `### Added` bullet under `## [Unreleased]` in `CHANGELOG.md` before
  starting the cycle.
