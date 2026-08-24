# Badadau Phase 1A — Application Bar / Transport Study

Status: ready for implementation  
Reviewed: 2026-08-24  
Base: Ardour 9.8.0

## Objective

Replace Ardour's dense application/transport presentation with a compact Badadau shell **without rewriting transport semantics**.

Target default information hierarchy:

```text
[workspace/navigation]   [transport]   [position]   [tempo] [meter] [loop] [metronome]   [engine/status]
```

Advanced recording/sync/monitor controls remain available contextually or through menus/actions instead of occupying permanent horizontal space.

## Existing source map

### `gtk2_ardour/transport_control_ui.{h,cc}` — preserve

This class is already a good integration seam. It maps UI buttons to semantic `ActionManager` actions:

- `Transport/ToggleClick`
- `Transport/Stop`
- `Transport/Roll`
- `Transport/Record`
- `Transport/GotoStart`
- `Transport/GotoEnd`
- `Transport/Loop`
- `Transport/PlaySelection`
- `MIDI/panic`

It also maps session state back onto buttons and handles loop sensitivity / record blinking.

**Decision:** do not duplicate this behavior. Either reuse `TransportControlUI` directly with a Badadau layout mode, or extract/reuse the action/state binding in a smaller Badadau transport component.

### `gtk2_ardour/application_bar.{h,cc}` — simplify/refactor

`ApplicationBar` currently owns a very broad set of concerns:

- transport controls;
- auto-return, external sync and shuttle;
- punch in/out and record mode;
- latency/PDC state;
- primary + secondary clocks;
- cue recording/playback state;
- monitor DIM/MONO/MUTE;
- solo/audition/feedback alerts;
- optional time information, mini timeline and editor master meter;
- up to 12 Lua action buttons.

The layout is assembled as a multi-column `Gtk::Table`, with many controls conditionally hidden/shown through UI configuration.

The same `ApplicationBar` class is instantiated by:

- `Editor`;
- `Mixer_UI`;
- `RecorderUI`;
- `TriggerPage`.

**Decision:** change the shared component carefully. A visual rewrite here affects all primary workspaces, which is useful for consistency but increases regression scope.

### `gtk2_ardour/audio_clock.cc` — reuse tempo/meter behavior

The existing transport clock already obtains the current `TempoMetric` at the playhead and exposes:

- current tempo;
- current time signature;
- actions/tooltips to change both while in BBT mode.

**Decision:** do not invent a second tempo-map implementation. Badadau's compact BPM / time-signature chips should reuse or factor the existing clock/tempo-map interaction.

### `gtk2_ardour/ardour_ui.{h,cc}` + `ardour_ui_ed.cc` — DSP/xrun status

DSP load currently lives in the global status area rather than `ApplicationBar`:

- `AudioEngine::instance()->get_dsp_load()` feeds `dsp_load_label`;
- the status widget also participates in xrun handling and opens performance/DSP diagnostics.

**Decision:** Badadau may visually promote a compact DSP/xrun status chip to the top bar, but should reuse the existing update/diagnostic path rather than create another polling subsystem.

## Proposed default Badadau bar

Keep always visible:

```text
| workspace | start | play | stop | record | position | BPM | 4/4 | loop | metronome | DSP/status |
```

Contextual/overflow instead of permanent:

- MIDI panic;
- play selection;
- external sync;
- shuttle/varispeed;
- auto return;
- punch in/out;
- layered/non-layered/sound-on-sound record mode;
- PDC disable / route latency;
- DIM/MONO/MUTE monitor controls;
- cue controls;
- secondary clock;
- mini timeline;
- Lua quick-action slots.

Nothing above is removed from the action system. It is only removed from the default visual hierarchy.

## Interaction requirements

- `Space`/existing transport shortcuts continue to work unchanged.
- Every visible control must have an ActionManager-backed semantic action where one exists.
- BPM and meter controls must be keyboard focusable and editable.
- Metronome state must have a non-color cue (icon/state/accessible value).
- Record must expose armed/recording state clearly without depending on blinking alone.
- DSP/xrun status must remain discoverable and open the existing detailed diagnostic path.
- The bar must fit a practical laptop width without hiding the primary transport.
- Advanced controls can be revealed by a single overflow/context action, not buried across unrelated menus.

## Implementation sequence

1. Introduce Badadau layout mode inside `ApplicationBar` first, rather than a parallel engine-facing class.
2. Keep `TransportControlUI::map_actions()` and session-state mapping intact.
3. Build a compact first row from existing controls/actions.
4. Factor BPM/time-signature display/editing from existing `AudioClock` behavior where possible.
5. Add compact engine/DSP status by reusing the existing ARDOUR_UI update path.
6. Move expert controls to an overflow/advanced popover/menu while keeping their actions available.
7. Apply the shared bar to Editor/Mixer/Recorder/Trigger Page and test each workspace.
8. Only after the behavior is stable, remove dead layout code or split `ApplicationBar` into smaller components.

## What not to do in Phase 1A

- no transport-engine rewrite;
- no TempoMap rewrite;
- no new audio-thread polling;
- no removal of expert actions;
- no full GTK/YTK migration;
- no unrelated Mixer/Browser redesign in the same commit.

## Acceptance test

A user should immediately find Play / Stop / Record / Loop / Metronome / Position / BPM / Time Signature, while an experienced Ardour user must still be able to reach sync, punch, record modes, monitor controls and diagnostics.
