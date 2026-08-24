# Badadau Fork Notes

## Current bootstrap

```bash
./configure-badadau.sh
./waf
```

The product name is `Badadau`. Build/config data uses the `badadau<major>` namespace so development builds can coexist with upstream Ardour profiles.

## Licensing rule of thumb

Private modification does not require publishing our changes. If we distribute a derivative executable, recipients must receive GPL rights and must be able to obtain the complete corresponding source for that exact binary. Keep upstream copyright/license notices and mark modified upstream files.

Plugins loaded through standard third-party plugin APIs are treated by Ardour's COPYING clarification as independent from the host; plugin licensing must still be respected independently.

## Branding

The current Badadau icon/splash are placeholders created for this fork. Do not restore upstream Ardour logos as Badadau product branding. We can replace the placeholders when the visual identity is finalized.

## First configure validation

The modified Waf scripts pass Python syntax validation and the new XML/theme files parse successfully. A Linux configure attempt currently stops at Ardour's mandatory ALSA development check because this sandbox does not provide the `alsa` pkg-config package. On Debian/Ubuntu this is normally supplied by `libasound2-dev`. This is an environment dependency, not a fork-code error.

## Research guardrails

`BADADAU_TECH_RESEARCH.md` is the living reference for external DAW/product research and source-code/license observations. Before adding a new subsystem, record whether it reuses Ardour primitives, merely studies another product, or adapts external source.

Current findings: Ardour 9.8 has no SQLite or DAWproject dependency in the inspected core/UI tree; VST2/VST3 scanning already uses dedicated scanner executables and caches. The Badadau Browser should consume those caches asynchronously rather than inventing a second plugin scanner.
