# Badadau Upstream Sync Policy

Status: active policy  
Base import: Ardour 9.8.0 source  
Baseline commit: `378931f`

Badadau is a product fork, not an engine rewrite. The purpose of this policy is to keep security, crash, plugin-hosting, session and realtime fixes from Ardour reasonably mergeable while allowing Badadau to develop a distinct UX.

## Branch and commit rules

1. Keep the pristine imported Ardour source identifiable forever. Tag `378931f` as `ardour-9.8.0-import`.
2. Keep Badadau product changes in small thematic commits: identity, shell, Browser, MIDI workflow, Mixer, etc.
3. Never combine an upstream import/sync with an unrelated Badadau feature in the same commit.
4. Avoid wholesale formatting, include-order or whitespace churn in inherited files.
5. Prefer adding Badadau-specific classes/adapters over rewriting large upstream classes when either design is reasonable.
6. When a change can live behind an ActionManager action or a small UI composition layer, prefer that to altering engine semantics.

## Sync cadence

- Follow Ardour 9.x stable releases and high-value fixes that affect crashes, session integrity, plugin hosting, realtime behavior, platform compatibility or MIDI correctness.
- Do **not** chase every nightly build merely because one exists.
- A nightly/upstream commit is worth importing early when it fixes a blocker we can reproduce in Badadau.
- Re-evaluate the base at the start of each Badadau milestone/release candidate.

## Sync procedure

Until this imported tarball is attached to a matching upstream Git history:

1. obtain the exact upstream source/tag/commit to evaluate;
2. create a dedicated `upstream-sync/<version-or-sha>` working branch;
3. compare upstream against our known baseline and isolate upstream-only changes;
4. apply/import upstream changes without Badadau feature work mixed in;
5. resolve conflicts in a separate conflict-resolution commit when practical;
6. reapply/adjust Badadau integration seams rather than silently dropping upstream behavior;
7. merge only after the validation gates below pass.

If/when Badadau is attached to Ardour's real Git history, use a normal `upstream` remote and preserve the same separation of upstream-sync and product commits.

## Validation gates after a sync

At minimum:

- configure/build on supported CI targets;
- open/save/reopen a stock Ardour session in Badadau;
- open/save/reopen a Badadau session;
- verify Badadau `Extra` metadata survives where applicable;
- basic audio record/playback/export smoke test;
- MIDI record/edit/playback smoke test;
- VST3/LV2 scan + instantiate smoke test;
- Trigger/Launcher smoke test;
- profile/config isolation from upstream Ardour;
- inspect renamed resources/desktop IDs for regressions.

## Conflict priority

When upstream and Badadau disagree:

1. session integrity and realtime correctness;
2. plugin compatibility and crash fixes;
3. cross-platform behavior;
4. Badadau semantic workflow;
5. Badadau visual styling.

Visual differences should almost never block importing an upstream correctness fix.

## Long-term goal

Keep `libs/ardour/` as close to upstream as product requirements allow. Concentrate Badadau differentiation in actions, adapters, new services and the UI layer. Deep engine divergence requires an explicit ADR describing why the product value justifies the maintenance cost.
