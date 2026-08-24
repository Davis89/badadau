# Contributing to BADADAU

BADADAU is an early-stage fork of Ardour with a strong emphasis on product workflow and maintainable divergence from upstream.

## Before contributing

Please read:

- `BADADAU_ROADMAP.md`
- `BADADAU_TECH_RESEARCH.md`
- `BADADAU_UPSTREAM.md`

For UI work, also read `BADADAU_PHASE1A_NOTES.md`.

## Development workflow

Use short-lived feature branches created from `main`.

Suggested branch names:

- `phase-1a-application-bar`
- `browser-indexing`
- `piano-roll-scale-workflow`
- `fix/<short-description>`
- `docs/<short-description>`

Open a pull request back to `main` when the change is ready for review.

## Scope and upstream policy

Prefer changes in this order:

1. Product/UX composition using existing Ardour capabilities.
2. BADADAU-specific UI or workflow code with a narrow interface to the engine.
3. Engine changes only when a clear product requirement cannot be met cleanly otherwise.

Before modifying engine behavior, consider session-format compatibility, tests, real-time safety, upstream merge cost, and whether the same result can be achieved in the UI or scripting layer.

## Coding expectations

- Preserve existing copyright and license headers.
- Mark modifications to upstream files when required by the applicable license/header practice.
- Follow the style of the surrounding Ardour code.
- Avoid unrelated formatting changes.
- Keep commits focused and explain non-obvious architectural decisions.
- Do not add generated binaries, build output, proprietary SDKs, plugin binaries, or third-party assets without a license review.

## Testing

At minimum, describe what you tested in the pull request. Changes affecting sessions, MIDI editing, routing, plugins, transport, automation, or persistence should include a reproducible regression scenario and, where practical, an automated test.

## Commit messages

Use concise imperative summaries, for example:

```text
ui: simplify application transport bar
midi: expose linked-copy workflow
browser: add asynchronous plugin index model
fix: preserve inherited scale after reload
```

## Pull requests

A pull request should explain:

- What user problem it solves.
- What changed.
- How it was tested.
- Any session-format, licensing, or upstream-sync impact.
- Screenshots for visible UI changes when useful.

Large features should be split into reviewable steps where possible.
