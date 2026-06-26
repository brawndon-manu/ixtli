# Runbook

Steps to stand up the environment and run the demonstration.

## Prerequisites

- docker
- kind (or k3s)
- kubectl
- helm
- sigma-cli

## Bring up the environment

```bash
make up        # kind cluster
make deploy    # falco + falcosidekick + sample workload
make convert   # sigma -> falco
```

## Validate locally

```bash
make validate  # run the attack sims and assert each rule fired
```

## Run the demo

```bash
make attack    # point the offensive driver at the sample workload
# the alert lands in the configured sink; trace it back to the rule and ATT&CK technique
```

## Tear down

```bash
make down
```

## Troubleshooting

- TODO: Falco not emitting events
- TODO: Falcosidekick not reaching the sink
- TODO: a rule that should fire but does not
