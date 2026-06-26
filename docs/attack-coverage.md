# Attack coverage

The detail behind the coverage matrix in the README, with one row per rule. The
intent is to organize detections around adversary behavior (MITRE ATT&CK
techniques) rather than isolated alerts, and to state clearly which techniques
are not yet covered.

## Covered

| Rule | ATT&CK | Trigger | Validated by |
|---|---|---|---|
| Shell in a container | T1059 | interactive shell in a running pod | TODO: atomic test id |
| Sensitive file read | T1552 | read of /etc/shadow or cloud cred paths | TODO |
| Suspicious outbound | T1071 | unexpected egress from a pod | TODO |
| Priv-esc attempt | T1548 | setuid / capability escalation | TODO |

## Not yet covered

Techniques currently out of scope, listed so the boundaries of coverage are
explicit rather than assumed. Expanded as the rule set grows.

- TODO

## Coverage means tested

A rule enters the covered table only once an attack simulation in CI confirms it
fires. Until then it remains under "not yet covered," even if the rule file
already exists. A written rule is not coverage; a tested one is.
