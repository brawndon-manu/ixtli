# Architecture

This expands on the diagram in the README and records the design decisions
behind Ixtli.

## Build time and run time

Ixtli has two halves that meet at a single artifact: a validated set of Falco
rules.

At build time (CI), the Sigma rules in Git are the source of truth. Every commit
lints them, compiles them to Falco, provisions an ephemeral cluster, runs the
matching attack, and verifies the rule fired. A rule that stays silent fails the
build, so nothing reaches the running cluster until it has demonstrated it can
detect what it claims to.

At run time, a kind/k3s cluster runs the sample workload with Falco monitoring
syscalls and the Kubernetes audit log. When a rule triggers, Falco emits an
event, Falcosidekick forwards it to a visible sink (currently Slack), and the
alert carries enough context to trace back to the rule and its ATT&CK technique.

## Why Sigma is the source of truth

Falco rules are what execute, but I author them in Sigma first and generate the
Falco version. Two reasons:

- Sigma is vendor neutral, so the same rule can target another backend later
  without a rewrite.
- Treating the generated Falco rules as build output keeps a single editable
  source. If the rules that actually run could be hand-edited, the version
  history would no longer reflect what is deployed.

## Trust boundary

The attacker (VectorForge or an Atomic/scripted test) only interacts with the
sample workload's exposed surface. Falco runs on the node and observes behavior
rather than the attacker directly. This is deliberate: the rules key on what a
compromise does (spawning a shell, reading a credential file, opening an
unexpected outbound connection) rather than on identifying a specific tool, so
they generalize to attacks that were not scripted in advance.

## Open decisions

- kind vs k3s for the run-time cluster (CI will almost certainly use kind)
- a single alert sink for the demo, or an additional dashboard
- whether generated Falco rules are committed or built fresh on deploy
