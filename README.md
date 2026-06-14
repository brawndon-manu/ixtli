<pre align="center">
 ██╗
 ╚═╝
██╗██╗  ██╗████████╗██╗     ██╗
██║╚██╗██╔╝╚══██╔══╝██║     ██║
██║ ╚███╔╝    ██║   ██║     ██║
██║ ██╔██╗    ██║   ██║     ██║
██║██╔╝ ██╗   ██║   ███████╗██║
╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝
</pre>
<p align="center">
  <strong>Īxtli — detection-as-code for Kubernetes.</strong>
</p>

Ixtli (Nahuatl for "eye") is runtime threat detection for a Kubernetes cluster, built so the detection rules are treated like actual code: they live in Git, they're written in Sigma, and they get tested in CI on every commit. If a rule stops firing, the build breaks. That's the whole idea — most detection rules rot quietly in a console and nobody notices until the alert that should've gone off doesn't.

The fun part: it attacks itself to prove the rules work.

Part of a small portfolio — see [Nahui](#) (supply chain security) and [Bastión Xólot](#) (network gateway). Nahui makes sure only trusted code ships; this watches what that code actually does once it's running.

## Why bother

Detection rules usually get written by hand, once, and then forgotten. There's no version history, no tests, no way to know a rule still works after someone edited it three months ago. So the goal here was to treat detections the same way you'd treat any other code:

- rules live in Git and go through pull requests
- they're written in Sigma, so they're not locked to one vendor
- CI runs simulated attacks and checks each rule actually fires
- every rule maps to a MITRE ATT&CK technique so coverage is legible

## How it works

```
  Sigma rules in Git  -- push -->  CI (GitHub Actions)
                                    - lint
                                    - convert Sigma -> Falco
                                    - spin up throwaway cluster
                                    - run Atomic Red Team attacks
                                    - fail the build if a rule stays silent
                                          |
                                          v  validated rules deployed
  +------------------------------------------------------------+
  |  kind / k3s cluster                                        |
  |                                                            |
  |   sample app  <-- attack -- VectorForge / scripted         |
  |      |                                                     |
  |      | syscalls + k8s audit                                |
  |      v                                                     |
  |   Falco --> Falcosidekick --> Slack / webhook              |
  +------------------------------------------------------------+
```

## The part I'm actually proud of

I'd already built [VectorForge](#) — an autonomous pentest agent that uses A\* search to attack HackTheBox machines. So instead of faking an attack for the demo, I point VectorForge at this cluster and watch the detections catch it.

So it's the same person's offense and defense in one place. That was the goal: show I can sit on both sides of it, not just deploy Falco and call it a day.

## What I built vs. what I just used

Worth being upfront about this, since it's easy to assume a security repo is 90% other people's tools:

Built: the detection rules, the CI pipeline that validates them, the alert routing, the ATT&CK coverage matrix, and (separately) VectorForge as the attacker.

Used off the shelf: Falco (the detection engine), Atomic Red Team (the attack library for CI), Falcosidekick (alert fan-out), and the Sigma tooling. These are the standard tools — the work is wiring them into something that's tested and actually holds together, not rebuilding a detection engine from scratch.

## Detection coverage

Each rule maps to a MITRE ATT&CK technique. Filling this in as I go:

| Rule | ATT&CK | What sets it off |
|---|---|---|
| Shell in a container | T1059 | Interactive shell spawned in a running pod |
| Sensitive file read | T1552 | Something reads `/etc/shadow` or cloud cred files |
| Suspicious outbound | T1071 | A pod makes an egress connection it shouldn't |
| Priv-esc attempt | T1548 | setuid / capability escalation |

## Running the demo

```bash
# rules + the CI run that signed off on them
git log detections/

# throw the attacker at the sample app
./vectorforge --target sample-workload      # or an Atomic Red Team test

# alert fires: Falco catches it, Falcosidekick routes it, it lands in Slack

# then I point at the exact rule + ATT&CK technique that caught it
```

## Status / roadmap

- [ ] cluster + Falco running, sample app deployed
- [ ] first custom rules + alerts landing in Slack
- [ ] rules moved into Git as Sigma
- [ ] CI: lint + throwaway cluster + Atomic Red Team, build fails on silent rules
- [ ] ATT&CK coverage matrix
- [ ] VectorForge demo recorded

Maybe later:
- [ ] auto-isolate or kill a pod when a rule trips
- [ ] a live coverage dashboard
- [ ] write-up on tuning a noisy rule (the actually-hard part of detection work)
- [ ] compile the same Sigma rule to a second backend to show it's portable

## Stack

Falco · Sigma · Atomic Red Team · Falcosidekick · MITRE ATT&CK · GitHub Actions · kind/k3s

## License

MIT
