# Detections

Detection rules are authored in Sigma and compiled to Falco.

- `sigma/` is the source of truth: hand-written, one rule per file, and the only
  place I edit rules.
- `falco/` holds generated output from `pipeline/convert.sh` and is not edited by
  hand. Generated rules are written to `falco/generated/`, which is gitignored as
  a build artifact.

Each rule maps to a MITRE ATT&CK technique (see `docs/attack-coverage.md`) and
requires an attack simulation that proves it fires in CI. A rule without a test
does not count as coverage.
