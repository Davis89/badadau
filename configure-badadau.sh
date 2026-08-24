#!/usr/bin/env bash
set -euo pipefail

# Badadau fork bootstrap: keeps the build identity explicit even though Badadau is now the default.
exec ./waf configure --program-name=Badadau "$@"
