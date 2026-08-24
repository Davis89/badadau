# BADADAU

**BADADAU** is an open-source digital audio workstation focused on a fast, modern music-production workflow.

BADADAU is in early development and is built from the Ardour 9.8.0 codebase. The project keeps Ardour's mature audio engine, routing, recording, plugin hosting, and session infrastructure while redesigning the production workflow, interface, and creative tooling around them.

## Goals

- Fast, modern music-production workflow.
- Clear `Browser | Arrangement | Inspector` workspace.
- Integrated Mixer, Piano Roll, Clip Launcher, and Automation views.
- Unified browser for plugins, presets, samples, loops, MIDI, and templates.
- Strong MIDI composition workflow: scales, chords, ghost notes, transforms, and drum editing.
- Reusable linked MIDI content and, later, reusable automation clips.
- Minimal engine divergence unless a product requirement clearly justifies it.
- Straightforward synchronization with upstream Ardour where practical.

## Status

BADADAU is **pre-alpha** and is not yet intended for production use.

Current work is focused on the application shell and workflow redesign while retaining the Ardour 9.8.0 engine baseline.

Project documents:

- [`BADADAU_ROADMAP.md`](BADADAU_ROADMAP.md) — development roadmap.
- [`BADADAU_TECH_RESEARCH.md`](BADADAU_TECH_RESEARCH.md) — architecture and DAW research.
- [`BADADAU_PHASE1A_NOTES.md`](BADADAU_PHASE1A_NOTES.md) — current UI/transport work.
- [`BADADAU_UPSTREAM.md`](BADADAU_UPSTREAM.md) — upstream synchronization policy.
- [`BADADAU_FORK_NOTES.md`](BADADAU_FORK_NOTES.md) — fork identity and implementation notes.

## Build

The build system is inherited from Ardour. BADADAU adds a convenience bootstrap script:

```sh
./configure-badadau.sh
./waf
```

Platform-specific dependencies are still largely the same as Ardour's. Reproducible CI builds and BADADAU-specific build documentation are planned as the project stabilizes.

## Relationship to Ardour

BADADAU is a modified work based on **Ardour**. Ardour is developed independently by the Ardour project and its contributors. BADADAU is not an official Ardour release and should not be presented as one.

The project preserves upstream copyright and license notices and aims to keep engine-level divergence controlled so useful upstream fixes can continue to be integrated.

## Contributing

Contributions are welcome, especially around testing, UX research, documentation, MIDI workflow, and carefully scoped implementation work. Please read [`CONTRIBUTING.md`](CONTRIBUTING.md) before opening a pull request.

## License

The Ardour-derived code in this repository is distributed under the terms stated in [`COPYING`](COPYING), principally **GNU GPL version 2 or later**. Individual files and bundled third-party components may contain additional copyright and license notices; those notices remain applicable.

The BADADAU name and original branding assets are project identity and are separate from the software copyright license.
