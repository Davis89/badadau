# Badadau Technical & Product Research

Status: living research log  
Last review: 2026-08-24  
Base under study: Ardour 9.8.0

This document records product lessons, source-code references, licensing constraints, and architecture decisions that should influence Badadau. It is intentionally separate from the roadmap: research may change; accepted work belongs in `BADADAU_ROADMAP.md`.

## Research rules

1. **Copy behaviour, not pixels.** Proprietary DAWs are UX/product references only.
2. **Inspect source before reinventing.** Open-source projects can reveal edge cases and architecture, but source reuse requires explicit license review.
3. **Prefer Ardour primitives.** Badadau should wrap or extend Ardour's engine, actions, session model, plugin manager and Trigger system instead of replacing mature subsystems.
4. **Keep the audio thread boring.** Search, indexing, previews, analysis and metadata work must not block realtime audio or the main UI thread.
5. **Record provenance.** Any source code directly adapted from another project must record origin, exact license and copyright before it enters the tree.

## Current product references (2026)

### Bitwig Studio 6 — highest architectural relevance

What matters:

- clip aliases: multiple placements can share one editable pattern while retaining placement-specific settings;
- reusable automation clips;
- key-signature-aware editing;
- stronger editing tools without making the launcher and arranger separate products;
- sandboxed plug-in hosting remains a strong reliability reference.

Badadau implication:

- before implementing aliases, separate **content identity** from **placement identity** in the design;
- automation clips should be considered as reusable content rather than only lane-local point lists;
- Arrangement and Launcher should converge on compatible clip semantics.

Status: **design for this now; implement later after Ardour model audit.**

### Ableton Live 12.4 — browser, accessibility and non-blocking UI

What matters:

- search/filter/tag workflows continue to be treated as a core creation surface;
- recent Live 12 work has moved expensive browser/library operations away from UI-blocking paths;
- accessibility and keyboard focus are being continuously improved, not added only at the end;
- bounce/render and collaboration/network-audio workflows are increasingly immediate.

Badadau implication:

- Browser indexing must be asynchronous from day one;
- keyboard navigation and accessibility metadata are Phase 1/2 requirements, not cleanup tasks;
- previews and search results should appear incrementally while indexing continues.

Status: **adopt as architecture principle.**

### FL Studio 2026 — capture-first workflow and MIDI ergonomics

What matters:

- chord detection directly in Piano Roll;
- Chord Stamp voice-leading modes;
- editable Piano Roll note labels;
- Audio Logger retains the last 60 seconds of master output so unrecorded ideas can be recovered;
- large plugin-list performance remains an explicit product concern.

Badadau implication:

- add chord/scale intelligence to the Piano Roll without requiring a separate theory window;
- research a future **Retrospective Capture** feature for both MIDI and audio;
- keep drum note naming/maps and user labels first-class.

Status: **Piano Roll priority; retrospective audio capture requires engine/buffering audit.**

### REAPER 7.79 — actions as an API + pooled automation items

REAPER 7.79 is current as of 2026-08-17.

What matters:

- actions, mouse modifiers, custom menus and scripts form a durable user-facing automation API;
- many workflow improvements ship as composable actions instead of monolithic modes;
- Automation Items provide movable/loopable automation blocks; pooled instances share editable source data while retaining placement/instance properties;
- the public ReaScript API exposes an explicit pool ID plus position, length, source offset, play rate, baseline, amplitude, loop and mute state.

Badadau implication:

- new toolbar/menu/command-palette features should invoke existing or new `ActionManager` actions;
- Lua scripts should be able to call the same semantic commands as GUI controls;
- avoid implementing behaviour only inside a widget callback;
- for reusable automation, study both Bitwig's Pattern/placement split and REAPER's pool-ID/content-plus-instance model. Ardour's current `AutomationList` is lane-bound, so Badadau should add an explicit reusable content identity rather than pretending the lane itself is a clip.

Status: **actions: adopt immediately; automation-item semantics: architecture reference for Phase 7.**

### Cubase 15 — expressive MIDI and interchange

What matters:

- redesigned Expression Maps integrated with Key/Score editing;
- melodic Pattern Sequencer with mono/poly step entry, scales, generators and randomization;
- expanded modulators;
- startup Hub, MediaBay search and hot-swap workflows;
- DAWproject session interchange.

Badadau implication:

- articulations/expression need a model that can later drive orchestral workflows;
- pattern generation can be delivered first as MIDI transformations/Lua tools;
- DAWproject import/export is a valuable medium-term interoperability target.

Status: **design MIDI metadata carefully; schedule DAWproject after core session UX.**

### Fender Studio Pro 8.1 (formerly Studio One Pro) — friction removal

Studio One Pro was renamed Fender Studio Pro in January 2026. Current 8.1 work emphasizes drag-and-drop, overview/navigation, native stem separation, audio-to-note, chord assistance and in-DAW help.

Badadau implication:

- product renames illustrate why our config/session identifiers should stay stable after Badadau is public;
- features should preserve editability and keep users inside the session;
- AI/assistant features are not a Phase 1 dependency and must not distort the core architecture.

Status: **workflow reference, not implementation priority.**

## Open-source codebases

### Ardour 9.8.0 — foundation

Use directly. Key existing assets:

- mature realtime audio/session/routing engine;
- `ActionManager` action registry and binding system;
- Lua scripting;
- Trigger/Clip Launcher engine and UI;
- Piano Roll and MIDI model;
- plugin manager plus separate VST2/VST3 scanner executables;
- existing plugin metadata/cache infrastructure.

Important observations from this source tree:

- the supplied 9.8.0 base is exceptionally current: Ardour's public stable release is 9.7 (2026-06-05), while official nightly builds on 2026-08-24 are already 9.8.0; upstream-sync discipline matters more than usual because useful fixes can still land quickly;
- Ardour 9.5/9.7 already added a MIDI Tools sidebar, chord editing, reference/ghost notes and inline quantize workflow. The local 9.8 tree contains chord replace/invert/drop operations, chord-aware step entry and ghost/reference-note UI. Badadau Phase 4 should therefore focus on discoverability, gestures, scale/key coherence, multi-track context and transformations rather than duplicating those features;
- no SQLite dependency was found in `gtk2_ardour/` or `libs/`;
- no DAWproject implementation was found;
- plugin scanning already has dedicated scanner executables, so the Badadau Browser should consume cached plugin metadata rather than scan synchronously;
- plugin metadata already includes user tags, favorites/hidden state, creator/type information and search helpers;
- `SoundFileBrowser` / `SoundFileBox` plus the session `Auditioner` already provide sample metadata, seeking, autoplay/audition and tagging primitives; the unified Browser should refactor/reuse these rather than create a second preview engine;
- Ardour's `AudioLibrary` sample-tag store is conditional on optional LRDF support (`lrdf` is a non-mandatory build dependency and `--no-lrdf` exists). Therefore Badadau must not make core Browser tags/favorites depend exclusively on `AudioLibrary`; treat it as an import/provider source and keep Badadau's Browser index backend provider-neutral;
- MIDI region copies can intentionally share a `MidiSource`. Ardour already exposes `fork-region` / `fork-regions-from-unselected` actions which clone the source to break that linkage. This is a strong foundation for a clearer **Linked Copy / Make Unique** workflow;
- Trigger slots hold `std::shared_ptr<Region>`, so Arrangement/Launcher interoperability already meets at the Region abstraction;
- `Stateful::Extra` XML is preserved by Session (and several other Stateful objects). Badadau-specific session metadata can therefore live under an `Extra` child and survive a round-trip through upstream Ardour, provided we avoid changing core semantics upstream Ardour cannot understand;
- `AutomationList` is a stateful parameter-bound `Evoral::ControlList` with no placement abstraction. Reusable automation clips will likely need a placement/content layer above it rather than merely renaming existing lane data;
- Ardour 9.8 also contains a new 2026-era musical-key/scale subsystem that is much deeper than the UI suggests: `Session`, `Route`, `Region`, `Source` and `Processor` participate in a `ScaleProvider` hierarchy; `MusicalKey` can test/conform MIDI pitches; and `ChordProvider` can identify named chords. The Session Options dialog already exposes **Scale & Tuning**, tracks can override/remove an inherited scale, and the Piano Roll has key-enforcement policies to highlight in-scale notes, reject out-of-scale mouse insertion, hide out-of-scale draw candidates, or force edits lower/higher/nearest. Badadau should surface and unify this existing model instead of creating a second project-key system;
- treat the scale subsystem as **promising but still upstream-moving** until round-trip tests pass. Upstream history shows the hierarchy arriving during 2026 and still receiving core changes in August (`Session` scale UI on Aug 5; `own_scale()` on Aug 11; scale-definition fixes on Aug 19). Static inspection of the current 9.8/upstream master also shows persistence details that deserve regression tests before Badadau relies on inheritance: route state serializes `this->key()` even when the key may be inherited, Session state does not obviously serialize its own `ScaleProvider` state, and `ScaleProvider` writes `key-enforcement` while its loader currently asks for `Key-enforcement`. Do not patch these speculatively; first create focused save/reload tests and compare with incoming Ardour 9.8 changes;
- Ardour's `COPYING` clarification names CLAP as a third-party plug-in API, but this 9.8 source tree does **not** contain a CLAP host implementation. Do not advertise CLAP until implemented and tested.

### LMMS — GPL-2.0-or-later; high-value Piano Roll reference

Current source demonstrates:

- horizontal + vertical Piano Roll zoom models;
- ghost notes;
- step recording;
- quantization and note-length models including triplets;
- key, scale and chord models;
- velocity/panning edit lanes;
- semitone/scale/chord marking.

Use: **behaviour and edge-case reference.** Any source reuse must retain GPL/copyright provenance and be reviewed file-by-file.

### MusE — rich MIDI operation reference

Current Piano Roll code exposes mature operations such as:

- quantize;
- velocity modification;
- crescendo/decrescendo;
- note shift;
- overlap deletion;
- gate-time/fixed-length changes;
- transpose;
- multiple editing tools and controller views.

Use: **semantic reference for MIDI transformations and undo behaviour.** Repository-level license metadata is ambiguous, while inspected source files carry GPLv2 headers; therefore direct reuse requires per-file review.

### Qtractor — GPL-2.0-or-later; MIDI/editor and Linux integration reference

Current MIDI editor code includes:

- named note maps including General MIDI drum names;
- controller-name maps;
- explicit command/editor separation;
- long-lived Qt/C++ sequencing implementation.

Use: **MIDI maps, command design and Linux interoperability reference.** Do not port Qt widgets into Badadau's current GTK/YTK UI layer.

### Tracktion Engine — architecture reference only by default

License: GPL-3.0-or-later or commercial.

Its engine abstractions are useful to study, but directly copying GPLv3 code into Badadau would intentionally move the combined derivative to GPLv3-compatible distribution terms. Ardour is GPL-2.0-or-later, so that is possible in principle, but it is a strategic licensing change and should never happen accidentally.

Use: **study architecture; no source copying without an explicit license decision.**

### Zrythm (current repository) — UX/modern-toolkit reference only

The current repository uses a project-specific `LicenseRef-ZrythmLicense` plus per-file REUSE licensing and has moved to a C++23 / Qt6 / QML-oriented stack.

Use: **study architecture, migration costs and UX only. No source reuse without per-file clearance.**

### Stargate DAW — lower-priority GPLv3 reference

Interesting for integrated instruments/effects and split Python UI / native DSP ideas, but current public repository activity is lower than LMMS/Qtractor and GPLv3 reuse would have the same strategic consequence described above.

## Priority matrix — what Badadau should borrow conceptually

| Reference | Adopt early | Later | Explicitly avoid |
|---|---|---|---|
| Ardour 9.8 | engine, actions, session model, plugin scanners/cache, Trigger, current MIDI tools | deeper engine extensions | replacing mature realtime code without a measured need |
| Bitwig 6 | content/placement thinking, Linked Copy language, arranger/launcher parity | automation clips, project key, modulation | cloning its panel geometry or visual language |
| Live 12 | unified search, tags, saved searches, keyboard-first browser, accessibility discipline | similarity search/auto-tagging | browser work on the UI/audio thread |
| FL Studio 2026 | fast Piano Roll gestures, chord detection/voice-leading, note labels | retrospective capture | transplanting pattern-centric assumptions that fight Ardour sessions |
| REAPER | actions as public workflow API, scriptability | deeper customization surface | widget-only commands |
| Cubase 15 | articulation/expression and DAWproject lessons | pattern/generative tools | early complexity in Phase 1 |
| Fender Studio Pro | drag/drop and overview/navigation friction removal | stem/audio-to-note helpers | making AI a prerequisite for core creation |
| LMMS / MusE / Qtractor | MIDI semantics, edge cases, maps and transformation behavior | selective GPL-compatible source adaptation with provenance | copying UI/toolkit code wholesale |
| Tracktion / Zrythm / Stargate | architecture ideas | only after explicit license decision | accidental code reuse that changes licensing obligations |

The recurring pattern across current DAWs is not “more buttons”; it is **faster access to the same underlying power, reusable musical content, strong search, and less modal interruption**. That is the product direction Badadau should optimize for.

## Architecture decisions proposed from research

### ADR candidate 001 — Browser is a service, not a widget

The UI should be a consumer of an asynchronous content index.

The index must represent at least:

- plug-ins and plug-in metadata;
- presets;
- samples/loops;
- MIDI files;
- templates;
- favorites, user tags and recents;
- later: automation/MIDI transformation presets.

Do not perform filesystem crawling or plug-in scanning on the UI thread. Reuse Ardour's plugin cache/scanners. `AudioLibrary`/LRDF may feed legacy sample tags but cannot be the mandatory Badadau metadata backend because LRDF is optional at build time. For sample/preset indexing, first prototype a provider-neutral in-memory index with a serialized cache; evaluate SQLite/FTS only if query complexity, metadata durability or library size justifies adding the dependency.

### ADR candidate 002 — Commands before controls

Every new high-frequency workflow should have a semantic action/command before it gets a toolbar button or menu entry. GUI, keyboard bindings and Lua should share it.

### ADR candidate 003 — Preserve content/placement separation

Before alias clips or reusable automation clips are implemented, define separate concepts for:

- content/pattern identity;
- timeline/launcher placement;
- placement properties (start, length, gain, launch settings, etc.);
- shared edits versus Make Unique.

Ardour Regions already distinguish sources and region instances in useful ways. The current source confirms that MIDI region copies can share the same `MidiSource`, and the existing *fork/unlink* actions clone that source when independence is requested. Badadau should prototype linked MIDI clips by surfacing this behaviour first. A separate pattern object should be introduced only if audio/automation/Launcher requirements cannot be expressed cleanly through the existing Region/Source model.

### ADR candidate 004 — Do not migrate GUI toolkit during product redesign

Qt6/QML and other modern stacks are attractive, but a full toolkit migration would turn Badadau into an infrastructure rewrite. Phase 1 should remain inside Ardour's current UI stack while we simplify shell/layout and establish product behaviour. Reassess rendering/toolkit modernization only after the new UX proves itself.

### ADR candidate 005 — DAWproject as interchange, not native format

DAWproject 1.0 is stable, open and MIT-licensed, packages project XML plus metadata/media/plugin state, and is supported by multiple commercial DAWs. Badadau should target import/export after its own core workflows stabilize. Ardour's native session format remains the native source of truth.

### ADR candidate 006 — Plugin-format priority

Near-term host priorities:

1. preserve/improve VST3;
2. preserve LV2;
3. preserve AudioUnit where applicable;
4. maintain legacy VST2 only to the level inherited from Ardour;
5. research CLAP as a distinct feature after the UI/browser architecture is stable.

Do not let a new format delay Phase 1/2.


### ADR candidate 007 — Badadau session extensions live under `Extra`

Ardour's `Stateful` layer explicitly loads, preserves and re-saves an `Extra` XML node. For Badadau-only metadata, prefer a dedicated child such as `<Extra><Badadau .../></Extra>` rather than adding arbitrary top-level session nodes.

Rules:

- include an explicit Badadau schema/version attribute;
- never move essential Ardour-readable data exclusively into the extension node;
- upstream Ardour should still be able to open the session with graceful loss of Badadau-only behaviour;
- test round-trip Badadau → Ardour → Badadau before relying on each new extension.

### ADR candidate 008 — Upstream-first fork maintenance

As of 2026-08-24, Ardour's public stable release is 9.7 while official nightly builds are already 9.8.0, matching the version family of our supplied base. Badadau should keep product/UI changes in small commits and maintain an explicit upstream-sync branch/policy so improvements and bug fixes from Ardour 9.x remain mergeable. Avoid broad formatting churn in upstream files.

### ADR candidate 009 — Keyboard and accessibility are part of component contracts

The inherited GTK/YTK/gtkmm stack already has focus management and ATK accessibility hooks, but many Ardour controls intentionally disable focus and canvas interactions are not automatically equivalent to conventional widgets. Every new Badadau Phase 1/2 component therefore needs an explicit interaction contract:

- every frequent action must be keyboard reachable;
- tab/focus order must follow visual/workflow order rather than widget-construction order;
- actionable widgets need meaningful accessible name, role and value/state where the toolkit exposes them;
- state must not be communicated by color alone;
- custom canvas gestures need an ActionManager/keyboard alternative;
- focus should remain predictable after dialogs, searches, drag/drop and workspace changes;
- hiding advanced controls must not remove the semantic action from shortcuts/scripts.

This is a design requirement, not an end-of-project compliance pass.

### ADR candidate 010 — One musical-key model: surface Ardour's `ScaleProvider`

Badadau should not introduce a parallel project-key object. Use the inherited `Session` key as the project default and preserve Ardour's hierarchical override model for tracks/regions where useful. Product work should focus on a clear global key/scale control, Piano Roll highlighting/fold behavior, and understandable per-track overrides.

Before shipping this as a core workflow, add save/reload regression tests for:

- Session key persistence;
- inherited versus owned Route scale identity;
- key-enforcement policy persistence;
- Badadau → upstream Ardour → Badadau round trips;
- MIDI edit/play behavior for ShowKey, NoInsert and force-to-scale modes.

The feature is new enough in Ardour 9.8 that Badadau should prefer upstream fixes when available rather than immediately forking the engine implementation.

## What this changes in the roadmap

Before Phase 1A implementation, complete a short **Phase 0.5 architecture guardrail** pass:

1. define stable Badadau product/config identifiers;
2. document ActionManager-first command policy;
3. sketch Browser index/service interfaces;
4. prototype linked MIDI clips using existing shared `MidiSource` + fork/unlink semantics before inventing a new pattern object;
5. adopt Ardour's existing `ScaleProvider`/`MusicalKey` hierarchy as the single project-key foundation and make persistence regression tests a Phase 4 gate;
6. design a placement/content layer for reusable automation clips above `AutomationList`;
7. define accessibility/keyboard requirements for new UI components;
8. use versioned Badadau metadata under Ardour's preserved `Extra` XML node;
9. create a license/provenance checklist for external source inspiration;
10. establish an upstream-sync policy for Ardour 9.x (`BADADAU_UPSTREAM.md`).

After these guardrails, proceed with Phase 1A top bar/transport knowing the UI shell will not box us into a dead-end architecture. The source-level implementation map is recorded in `BADADAU_PHASE1A_NOTES.md`.

## Research backlog

- Test `Extra/Badadau` session metadata round-trip through upstream Ardour.
- Add focused `ScaleProvider` persistence tests: Session key, Route inherited/owned key, key-enforcement flags and reload behavior; compare against upstream 9.8 before patching.
- Map the existing Session/Route scale UI into a single Badadau global Key/Scale control plus understandable track override workflow.
- Prototype user-facing Linked Copy / Make Unique on existing MidiSource linkage; audit audio parity.
- Design reusable automation content/placement layer above parameter-bound AutomationList.
- TriggerBox/Trigger relationships to Arrangement regions.
- Refactor `SoundFileBox`/`Auditioner` preview into a reusable Browser provider without duplicating playback logic.
- Out-of-process plug-in crash isolation feasibility beyond scanner isolation.
- Retrospective MIDI capture using existing input buffers.
- Retrospective audio capture cost and realtime-safety constraints.
- DAWproject C++ implementation approach and plugin-state mapping.
- CLAP host scope and upstream Ardour evolution before implementing independently.
- Audit custom Canvas items that need explicit ATK/action fallbacks beyond the general Phase 1 accessibility contract.
