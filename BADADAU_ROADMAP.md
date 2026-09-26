# Badadau Roadmap

Status: active prototype
Base: Ardour 9.8.0
Fork identity: **Badadau** (final working/product name)
License strategy: retain GPL-2.0-or-later compatibility and preserve upstream notices.

---

## Roadmap / Hoja de Ruta hacia la Versión Final 1.0 (Español)

Esta sección resume la estrategia y el calendario por hitos para alcanzar la **Versión Final 1.0 de Badadau**:

1. **Hito 1: v0.1 Alpha — Identidad de Producto y Shell Visual (Fases 0, 0.5 y 1)**
   - Identidad propia (iconos, splash, directorio de configuración `badadau9` independiente de Ardour).
   - Rediseño de la barra de transporte/aplicación superior y la disposición visual de paneles (Navegador | Arreglo | Inspector).
   - Menús simplificados y ocultación de controles avanzados en vista predeterminada.

2. **Hito 2: v0.5 Beta — Navegador Unificado y Flujo de Trabajo Rápido (Fases 2 y 3)**
   - Buscador unificado e indexación asíncrona para plugins, muestras, MIDI y plantillas.
   - Arrastrar y soltar desde el navegador con creación automática de pistas y cadenas de dispositivos.
   - Creación rápida de pistas mediante paleta de comandos (`Quick Add`).
   - Herramientas de Bounce in Place y congelado de pistas.

3. **Hito 3: v0.8 Beta Abierta — Piano Roll, Mezclador Simplificado y Lanzador de Clips (Fases 4, 5 y 6)**
   - Rediseño e integración fluida del Piano Roll (escalas, acordes, gestos rápidos de edición y humanización).
   - Mezclador con vistas compactas y reordenación directa de inserciones.
   - Matriz de Lanzador de Clips (Clip Launcher / Escenas) integrada con la línea de tiempo.

4. **Hito 4: v0.9 Candidate a Release (RC) — Herramientas Creativas, Automatización y Pruebas de Estrés (Fase 7 y Control de Calidad)**
   - Sistema de macros y scripts en Lua (sidechain automático, humanización, limpieza).
   - Verificación de estabilidad, rendimiento en tiempo real y compatibilidad bidireccional de sesiones con Ardour.
   - Cumplimiento estricto de licencias GPL-2.0+, eliminación de marcas registradas y auditoría de empaquetado (Linux/AppImage/Flatpak, macOS, Windows).

5. **Hito 5: v1.0 Versión Final — Lanzamiento Público**
   - Binarios estables multi-plataforma publicados junto al código fuente correspondiente exacto.
   - Documentación de usuario final y guías de migración desde Ardour y otras DAWs.

---

## Milestone Releases / Path to v1.0 Final

To reach a stable, production-ready **Badadau v1.0 Final**, development is structured into clear milestone releases:

### Milestone 1: v0.1 Alpha — Product Identity & Visual Shell (Phases 0, 0.5, 1)
- [x] Complete identity isolation (`badadau9` configuration namespace, splash, launcher, branding).
- [ ] Complete clean Linux builds and setup CI build scripts.
- [ ] Implement redesigned top application & transport bar.
- [ ] Finalize primary workspace layout (Browser | Arrangement | Inspector) and workspace lower tabs.
- **Target Goal:** Functional DAW shell distinguishable from stock Ardour, able to create, record, play, and save basic sessions.

### Milestone 2: v0.5 Beta — Unified Browser & Fast Workflow (Phases 2 & 3)
- [ ] Deliver unified asynchronous Browser for plugins, presets, samples, and templates with fuzzy search.
- [ ] Implement drag-and-drop auto-track creation and inline effect chains.
- [ ] Add Quick Add command palette for track and bus creation.
- [ ] Implement bounce-in-place and track freeze/unfreeze workflows.
- **Target Goal:** Complete song creation workflow without opening expert-level dialogs or menus.

### Milestone 3: v0.8 Open Beta — Surface Polish: Piano Roll, Mixer & Clip Launcher (Phases 4, 5 & 6)
- [ ] Streamline Piano Roll interaction: scale highlight/fold, quick chord entry, velocity manipulation, humanize/strum tools.
- [ ] Implement compact/detailed Mixer strips and direct insert reordering.
- [ ] Refine Clip Launcher / Scenes workflow with smooth Arrangement sync and linked clip copies.
- **Target Goal:** Feature-complete user interface with fluid music creation capabilities.

### Milestone 4: v0.9 Release Candidate (RC) — Creative Scripting, Stability & Compliance (Phase 7 & Audit)
- [ ] Package first-party Lua creation tools and script browser.
- [ ] Pass full session round-trip compatibility tests with upstream Ardour.
- [ ] Complete cross-platform binary build verification (Linux AppImage/Flatpak, macOS, Windows).
- [ ] Finalize trademark audit, GPL attribution check, and user documentation.
- **Target Goal:** Zero critical bugs, solid audio performance, full legal & open-source packaging compliance.

### Milestone 5: v1.0 Final Release
- Official public release of binaries alongside exact source code repositories.

---

## Product principles

1. **Keep the mature engine; redesign the experience.** Avoid deep DSP/audio-engine changes unless a product requirement demands them.
2. **One obvious path for common tasks.** Advanced Ardour capability remains available, but it should not dominate the default interface.
3. **Fast creation.** Track creation, plugin insertion, sample audition, MIDI editing, bounce/freeze and routing should require as few modal dialogs as practical.
4. **Keyboard + mouse first-class.** Every frequent action should be reachable without menu hunting.
5. **Progressive disclosure.** Normal mode for music production; advanced controls appear when requested.
6. **No imitation-by-pixels.** Learn interaction principles from other DAWs, but use original branding, layout details, assets and implementation.

## Reference products

- **Bitwig Studio:** linear + launcher integration, contextual browser, modulation model.
- **Ableton Live:** browser/search discipline, session/arrangement workflow, immediate device chains.
- **FL Studio:** piano-roll speed, note tools, pattern/beat editing.
- **REAPER:** action system, macros, scripting, routing flexibility and user customization.
- **Logic Pro:** approachable smart tools, chord/tempo workflows, integrated instruments and creative assistants.
- **LMMS / MusE / Qtractor:** inspectable open-source implementation ideas, especially MIDI/pattern/editor architecture.

## Phase 0 — Fork hygiene and build identity

Goal: a clean derivative that can be developed and installed beside Ardour.

- [x] Import pristine Ardour 9.8.0 source as baseline commit.
- [x] Set product name to Badadau.
- [x] Give Badadau its own config/data directory (`badadau9`) instead of `ardour9`.
- [x] Give the main executable/wrapper Badadau-specific names.
- [x] Make desktop/AppStream metadata use the product name.
- [x] Add original provisional splash/icon resources (no Ardour logo reuse).
- [x] Add `studio-badadau.colors` and make it the default fresh-profile theme.
- [x] Add `configure-badadau.sh`.
- [ ] Complete a clean configure/build on Linux. Current sandbox blocker: the `alsa` pkg-config development package is absent (`pkg-config --exists alsa` fails) before Ardour reaches the rest of dependency checks.
- [ ] Add CI build matrix later (Linux first, Windows/macOS after UI direction stabilizes).

Acceptance: Badadau launches with its own profile/resources and does not overwrite an Ardour profile.

## Phase 0.5 — Architecture guardrails before UI expansion

Goal: make the first UI redesign compatible with the Browser, clip aliases, automation clips and scripting we expect later.

- [x] Adopt an ActionManager-first policy: GUI controls, shortcuts and Lua should call the same semantic commands.
- [x] Define Browser service/index boundaries; all crawling/indexing/preview work must be asynchronous.
- [x] Reuse Ardour plugin caches/scanners; do not synchronously rescan plugins from Browser UI.
- [x] Audit initial `Region` / `Source` / `MidiSource` semantics: MIDI copies can share a source; prototype Linked Copy / Make Unique on existing fork/unlink actions.
- [x] Audit initial `AutomationList` ownership: it is parameter-bound lane data; reusable clips need a content/placement layer above it.
- [x] Audit Ardour 9.8 musical-key foundation: reuse `ScaleProvider`/`MusicalKey`; schedule save/reload regression tests before depending on its new inheritance/persistence behavior.
- [x] Define keyboard navigation, focus and accessibility requirements for every new Phase 1 component (keyboard reachability, logical focus order, accessible labels/roles/values, no color-only state, ActionManager fallback for canvas operations).
- [x] Define session-extension rule: versioned Badadau metadata goes under Ardour-preserved `Extra` XML and must round-trip through upstream Ardour.
- [x] Add external-code provenance/license rules in `BADADAU_TECH_RESEARCH.md`.
- [x] Record current research in `BADADAU_TECH_RESEARCH.md`.
- [x] Establish an Ardour 9.x upstream-sync policy and keep fork changes merge-friendly (`BADADAU_UPSTREAM.md`).

Acceptance: Phase 1 controls can be implemented without embedding business logic in widgets or blocking the UI with indexing/scanning work.

## Phase 1 — Visual shell and simplification

Goal: opening Badadau should no longer feel like stock Ardour.

- [ ] Define final design tokens: spacing, typography, panel surfaces, focus/selection, meters, warning states.
- [ ] Redesign top application/transport bar around record/play/loop/tempo/time signature/metronome/CPU.
- [ ] Establish primary workspace: Browser | Arrangement | Inspector.
- [ ] Establish lower workspace tabs: Mixer | Piano Roll | Clips | Automation.
- [ ] Simplify default menus; retain an Advanced path for full Ardour actions.
- [ ] Simplify track headers and expose only high-frequency controls by default.
- [ ] Audit dialogs and remove unnecessary modal steps.

Acceptance: a new user can create a project, add audio/instrument tracks, record and insert a plugin without navigating expert-level menus.

## Phase 2 — Unified Browser

Goal: one searchable place for creative material.

- [ ] Unified provider-neutral index/view for plugins, presets, samples, MIDI, templates and favorites; reuse Ardour plugin tags/status and import legacy AudioLibrary/LRDF tags without making optional LRDF the core metadata store.
- [ ] Fast fuzzy search and keyboard navigation.
- [ ] Filters/tags and user favorites.
- [ ] Audition samples from search results by refactoring/reusing `SoundFileBox` + session `Auditioner`.
- [ ] Drag results to tracks, plugin chains, clip launcher and empty space.
- [ ] Context-aware defaults (e.g. effect search when dropping on an insert slot).
- [ ] Persist search/filter views.

Acceptance: `Ctrl/Cmd+F`, type a few characters, Enter/drag, and the requested object is inserted with minimal friction.

## Phase 3 — Track and device workflow

Goal: make common production actions instant.

- [ ] Quick Add command palette for Audio / Instrument / Drum / MIDI / Bus / Return.
- [ ] Automatic track creation from browser drag-and-drop.
- [ ] Device chain UI with clear pre/post-fader semantics.
- [ ] Improved sidechain creation workflow.
- [ ] Bounce in place, freeze/unfreeze and render selection workflows.
- [ ] Track presets/templates.
- [ ] Plan DAWproject 1.0 import/export as an interoperability layer (not native session format).

Acceptance: adding an instrument or effect takes seconds and no routing knowledge for common cases.

## Phase 4 — Piano Roll and MIDI creation

Goal: make MIDI editing a headline feature. Ardour 9.8 already gives Badadau a stronger baseline than first assumed, so preserve those capabilities and redesign their workflow rather than rebuilding them.

Existing baseline to surface/polish:

- [x] Reference/ghost-note display exists in the inherited Piano Roll.
- [x] Chord insertion/editing, inversion and drop-note operations exist.
- [x] MIDI Tools/quantize controls exist in Piano Roll and Editor contexts.
- [x] Step Entry already supports chord entry and detailed note durations.
- [x] Ardour already distinguishes dependent/independent MIDI region copies.
- [x] Ardour 9.8 already has `MusicalKey` / hierarchical `ScaleProvider`, Session **Scale & Tuning**, per-track scale override/removal, scale-aware Piano Roll backgrounds and key-enforcement modes.

Badadau work:

- [ ] Faster draw/select/resize/duplicate gestures and an explicit Linked Copy modifier/action.
- [ ] Make multi-track context/reference notes obvious and easy to choose.
- [ ] Surface Ardour's existing Session `ScaleProvider` as Badadau's global project key/scale; unify highlighting and add fold-to-scale without creating a parallel key model.
- [ ] Velocity/CC lanes with better direct manipulation and faster lane switching.
- [ ] Humanize, strum, legato, quantize strength, randomize and note repeat as reusable actions/MIDI tools.
- [ ] Chord detection, voice-leading helpers and reusable MIDI transformations.
- [ ] Drum note naming/maps and user-defined note labels.
- [ ] Evaluate probability/ratchet semantics against Ardour's MIDI model before engine changes.

Acceptance: composing drums, chords and melodic parts should not require leaving the piano roll for routine transformations.

## Phase 5 — Mixer

Goal: retain Ardour routing power while making it easier to read.

- [ ] Compact / Normal / Detailed strip modes.
- [ ] Cleaner inserts/sends and drag reorder.
- [ ] Strong visual distinction for track/bus/return/master without excessive color noise.
- [ ] Search/add processor inline.
- [ ] Better gain staging and meter readability.
- [ ] Mixer snapshots/layout recalls after core UX stabilizes.

## Phase 6 — Clip Launcher / scenes

Goal: make nonlinear composition a peer of the timeline.

- [ ] Simplify trigger/scene terminology and visual hierarchy.
- [ ] Drag clips freely between Arrangement and Launcher.
- [ ] Linked Copy / Make Unique workflow, starting with Ardour's existing shared-MidiSource + fork/unlink semantics.
- [ ] Scene capture and record-to-arrangement workflow.
- [ ] Follow actions / launch behavior audit.
- [ ] Controller-first navigation after desktop UX is solid.

## Phase 7 — Automation, modulation and creative tools

Goal: turn Ardour's automation + Lua system into an extensible creative layer.

- [ ] Unified macro/action commands.
- [ ] First-party Lua tools: sidechain setup, humanize, drum bus, parallel processing, cleanup, bounce helpers.
- [ ] Explore track/device modulation as a distinct design project; do not force it into the engine prematurely.
- [ ] Script browser and discoverability.

## Phase 8 — Deep engine changes only where justified

Candidates, not commitments:

- probability/ratchet note semantics;
- deeper per-note expression workflows;
- modulation graph;
- device/container abstractions;
- new clip-launch behavior;
- performance/latency optimizations identified by profiling.

Every engine change needs: product requirement, test coverage, session-format impact review and upstream-merge cost estimate.

## Release gates

Before a public binary release:

- exact corresponding source published alongside/equally accessible to the binary;
- GPL and copyright notices preserved;
- modified-file notices audited;
- third-party dependency licenses audited;
- Ardour trademarks/logos removed from Badadau branding assets;
- About/Credits clearly acknowledge Ardour and upstream contributors;
- packaging tested side-by-side with upstream Ardour;
- session compatibility and migration behavior documented.
