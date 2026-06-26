# Attacks

The offensive side, organized into two categories.

- `atomic/` contains Atomic Red Team test selections, each mapped to the rule it
  exercises. These run in CI and serve as the ground truth for whether a rule
  fires.
- `scripted/` contains custom scripted attacks and the integration for running
  VectorForge against the cluster during the live demo.

The split is intentional: CI requires deterministic, repeatable attacks, while
the demo uses the full offensive tool.
