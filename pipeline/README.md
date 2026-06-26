# Pipeline

These scripts are invoked by both the Makefile and CI, so local and CI runs
behave identically.

- `convert.sh` compiles Sigma rules into Falco rules.
- `validate.sh` runs the attack simulations and fails if any rule does not fire.

Keeping the logic in standalone scripts rather than inline CI steps means the
same validation can be run locally before pushing.
