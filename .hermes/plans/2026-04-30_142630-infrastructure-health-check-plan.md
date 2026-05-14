# Infrastructure Health Check System Plan

> **Plan mode:** This document is a plan only. Do not execute remote probes, change services, restart containers, update packages, rotate logs, prune Docker, commit, push, or create skills until Pedro explicitly authorizes execution.

## Goal

Build a repeatable, read-only health-check workflow for every system reachable through Pedro's current SSH fleet, covering OS health, services, processes, logs, containers, networking, storage, backups, and role-specific application checks. After one successful manual/pilot run, package the proven workflow as a reusable Hermes skill.

## Current Context / Assumptions

Observed locally, read-only:

- Active workspace: `/Volumes/InternalSpareStorage/Projects/CascadeProjects/LunaLighthouse`
- `~/.ssh/config` exists.
- `~/.hermes/server-inventory.yaml` exists.
- `~/.ssh/config` currently exposes 13 concrete host aliases, all configured with IPv4 hostnames.
- Existing inventory contains 12 server entries.
- `github-runner-01` appears in `~/.ssh/config` but not in the current inventory summary.

Known aliases from SSH config:

- `mcp-behemoth`
- `cardinal-server-1`
- `cardinal-media-server`
- `technitium`
- `proxmox`
- `odoo`
- `nextcloud`
- `pivpn`
- `servarr`
- `cockpit-server`
- `security-onion`
- `zabbix`
- `github-runner-01`

Known inventory roles/policies:

| Alias | Role | Policy | Touch |
|---|---|---|---|
| `mcp-behemoth` | `mcp-host` | `primary` | `allowed` |
| `cardinal-server-1` | `rack-main` | `inspect-cautiously` | `allowed` |
| `cardinal-media-server` | `pending-classification` | `inspect-cautiously` | `unknown` |
| `proxmox` | `proxmox-host` | `primary` | `allowed` |
| `technitium` | `dns-server` | `inspect-cautiously` | `allowed` |
| `odoo` | `odoo-vm` | `inspect-cautiously` | `allowed` |
| `nextcloud` | `nextcloud` | `inspect-cautiously` | `normal` |
| `pivpn` | `vpn-lxc` | `inspect-cautiously` | `allowed` |
| `servarr` | `media-automation-lxc` | `inspect-cautiously` | `allowed` |
| `cockpit-server` | `cockpit-lxc` | `inspect-cautiously` | `allowed` |
| `security-onion` | `security-monitoring` | `inspect-cautiously` | `allowed` |
| `zabbix` | `zabbix-server` | `inspect-cautiously` | `normal` |

Assumptions:

- First implementation should be read-only and non-invasive.
- SSH host aliases are the source of truth for reachability; `~/.hermes/server-inventory.yaml` is the canonical role/policy layer.
- Hosts may vary: bare-metal Linux, Proxmox host, LXCs/VMs, Docker hosts, app-specific appliances/services.
- Some checks require `sudo`; the first pass should detect permission gaps instead of prompting or forcing escalation.
- Output should be useful at 2am: compact summary first, detailed evidence files second.

## Safety Policy

Hard rules for the health-check workflow:

1. **Read-only by default.** No restarts, package changes, pruning, migrations, container recreation, firewall edits, DNS edits, or service reloads.
2. **No secrets in output.** Redact tokens, keys, passwords, cookies, auth headers, private URLs with credentials, and connection strings.
3. **No destructive log operations.** Do not truncate, rotate, delete, or compress logs during health checks.
4. **No blind sudo.** Use `sudo -n` only for read-only commands where needed; record `sudo-required` if unavailable.
5. **No external notification spam.** Do not send reports anywhere except back to Pedro unless explicitly requested.
6. **Per-host timeout.** A hung host should not block the fleet report.
7. **Preserve raw evidence locally.** Store sanitized JSON/Markdown artifacts under a timestamped report directory.

## Proposed Architecture

Create a repeatable health-check bundle with three layers:

1. **Inventory layer**
   - Parse `~/.ssh/config` for aliases.
   - Merge role/policy from `~/.hermes/server-inventory.yaml`.
   - Classify unknown aliases as `pending-classification`.

2. **Probe layer**
   - Run read-only SSH commands per host.
   - Use role-aware probes for Proxmox, Docker/LXC hosts, DNS, Nextcloud, Odoo, Servarr, PiVPN, Zabbix, Security Onion, GitHub runner, and MCP host.
   - Capture structured results and command exit codes.

3. **Report layer**
   - Produce concise fleet summary with severity: `critical`, `warning`, `info`, `ok`, `unknown`.
   - Produce per-host markdown and JSON evidence.
   - Provide follow-up recommendations but do not fix anything automatically.

Candidate local paths for implementation phase:

- `~/.hermes/health-checks/config.yaml`
- `~/.hermes/health-checks/scripts/fleet_health_check.py`
- `~/.hermes/health-checks/reports/YYYY-MM-DD_HHMMSS/summary.md`
- `~/.hermes/health-checks/reports/YYYY-MM-DD_HHMMSS/results.json`
- Later skill path: `~/.hermes/profiles/devopsbuddy/skills/devops/infrastructure-health-checks/`

## Step-by-Step Plan

### Phase 0 — Confirm Scope Before Execution

Ask Pedro to approve:

- Whether all 13 aliases should be probed.
- Whether `github-runner-01` should be added to `~/.hermes/server-inventory.yaml`.
- Whether `cardinal-media-server` can be classified now or should remain `pending-classification`.
- Whether checks may use `sudo -n` for read-only commands.
- Whether reports should stay local only or also be sent to Telegram.

Do not proceed to remote probing until scope is explicit.

### Phase 1 — Inventory Reconciliation

Objective: make sure host list and roles are accurate before probing.

Read-only discovery commands:

```bash
python3 - <<'PY'
from pathlib import Path
# Parse ~/.ssh/config host aliases and compare to ~/.hermes/server-inventory.yaml.
# Print aliases missing from inventory and inventory entries missing from ssh config.
PY
```

Expected findings to verify:

- `github-runner-01` is in SSH config but not current inventory.
- 12 inventory entries are already present.

Planned output:

- `inventory_diff.md`
- `inventory_diff.json`

If Pedro approves inventory updates later, update `~/.hermes/server-inventory.yaml`; not during plan mode.

### Phase 2 — Define Universal Host Probes

Objective: create the base check set every Linux host gets.

Universal read-only SSH probe command groups:

```bash
hostname -f || hostname
uname -a
cat /etc/os-release 2>/dev/null || true
uptime
who -b 2>/dev/null || true
systemctl is-system-running 2>/dev/null || true
systemctl --failed --no-pager 2>/dev/null || true
df -hT
findmnt --real --noheadings --output TARGET,SOURCE,FSTYPE,OPTIONS 2>/dev/null || true
free -h
swapon --show 2>/dev/null || true
ps -eo pid,ppid,stat,%cpu,%mem,etime,comm --sort=-%cpu | head -25
ss -tulpn 2>/dev/null || sudo -n ss -tulpn 2>/dev/null || true
journalctl -p warning..alert --since '24 hours ago' --no-pager -n 200 2>/dev/null || sudo -n journalctl -p warning..alert --since '24 hours ago' --no-pager -n 200 2>/dev/null || true
last -n 10 2>/dev/null || true
```

Universal pass/warn thresholds:

- Disk usage:
  - warning: any real filesystem >= 80%
  - critical: any real filesystem >= 90%
- Memory:
  - warning: swap active with sustained memory pressure
  - critical: OOM kills in last 24h
- Services:
  - warning: `systemctl is-system-running` is `degraded`
  - critical: failed units related to networking, storage, database, proxy, app runtime, Docker, Proxmox, DNS, or monitoring
- Logs:
  - warning: repeated errors in last 24h
  - critical: kernel I/O errors, filesystem corruption, authentication storms, container runtime failure, backup failure
- Network:
  - warning: unexpected listeners exposed on `0.0.0.0`
  - critical: core app ports missing for role-specific services

### Phase 3 — Container And Runtime Probes

Objective: inspect Docker/Podman/LXC state without changing anything.

Generic container commands:

```bash
command -v docker >/dev/null && docker ps --format '{{json .}}' || true
command -v docker >/dev/null && docker ps -a --filter status=exited --format '{{json .}}' || true
command -v docker >/dev/null && docker stats --no-stream --format '{{json .}}' || true
command -v docker >/dev/null && docker system df || true
command -v podman >/dev/null && podman ps --format json || true
command -v pct >/dev/null && pct list || true
command -v qm >/dev/null && qm list || true
```

Container checks:

- restarting containers
- exited containers that should be persistent services
- containers with high CPU/memory
- Docker daemon errors in journal
- large dangling image/cache footprint, reported only; no prune
- unhealthy containers from Docker health checks

### Phase 4 — Role-Specific Probes

#### `proxmox` — Proxmox host

Read-only checks:

```bash
pveversion -v 2>/dev/null || true
pvecm status 2>/dev/null || true
pct list 2>/dev/null || true
qm list 2>/dev/null || true
zpool status 2>/dev/null || true
zfs list 2>/dev/null || true
cat /proc/mdstat 2>/dev/null || true
journalctl -u pvedaemon -u pveproxy -u pvestatd --since '24 hours ago' --no-pager -n 200 2>/dev/null || sudo -n journalctl -u pvedaemon -u pveproxy -u pvestatd --since '24 hours ago' --no-pager -n 200 2>/dev/null || true
```

Risk markers:

- degraded ZFS pool
- failed VM/LXC startup
- backup job failures
- cluster quorum issues
- high storage pressure on VM/LXC storage

#### `technitium` — DNS server

Use both SSH and existing Technitium MCP read-only tools where appropriate.

SSH checks:

```bash
systemctl status technitium-dns --no-pager 2>/dev/null || true
journalctl -u technitium-dns --since '24 hours ago' --no-pager -n 200 2>/dev/null || sudo -n journalctl -u technitium-dns --since '24 hours ago' --no-pager -n 200 2>/dev/null || true
ss -tulpn | grep -E '(:53|:5380|:853)' || true
```

MCP/read-only checks, if available:

- `dns_health_check`
- `dns_list_zones`
- `dns_get_settings`
- `dns_get_top_stats` for query/client anomalies

Risk markers:

- DNS service down
- port 53 not listening
- cache/blocklist update errors
- abnormal NXDOMAIN/SERVFAIL rates
- high query rate from a single client

#### `nextcloud` — Nextcloud host

Read-only checks:

```bash
systemctl --failed --no-pager 2>/dev/null || true
command -v docker >/dev/null && docker ps --format '{{json .}}' || true
find /var/www -maxdepth 3 -name occ 2>/dev/null | head -5
sudo -n -u www-data php /var/www/nextcloud/occ status 2>/dev/null || true
sudo -n -u www-data php /var/www/nextcloud/occ config:system:get maintenance 2>/dev/null || true
journalctl --since '24 hours ago' --no-pager -p warning..alert -n 200 2>/dev/null || true
```

Risk markers:

- maintenance mode enabled unexpectedly
- failed PHP-FPM/web server/database units
- Nextcloud log errors
- storage pressure
- trusted domain/config warnings

#### `odoo` — Odoo VM

Read-only checks:

```bash
systemctl --failed --no-pager 2>/dev/null || true
systemctl status odoo --no-pager 2>/dev/null || true
systemctl status postgresql --no-pager 2>/dev/null || true
journalctl -u odoo --since '24 hours ago' --no-pager -n 200 2>/dev/null || sudo -n journalctl -u odoo --since '24 hours ago' --no-pager -n 200 2>/dev/null || true
journalctl -u postgresql --since '24 hours ago' --no-pager -n 200 2>/dev/null || sudo -n journalctl -u postgresql --since '24 hours ago' --no-pager -n 200 2>/dev/null || true
```

Risk markers:

- Odoo service down
- database errors
- HTTP worker crashes
- disk pressure on filestore or database volume

#### `servarr` / `cardinal-media-server` — media automation

Read-only checks:

```bash
command -v docker >/dev/null && docker ps --format '{{json .}}' || true
systemctl --failed --no-pager 2>/dev/null || true
journalctl --since '24 hours ago' --no-pager -p warning..alert -n 200 2>/dev/null || true
```

Optional app HTTP checks only after Pedro confirms expected ports and whether local loopback checks are safe.

Risk markers:

- Arr containers down/restarting
- download clients unreachable
- media storage full
- permission errors against mounted media paths

#### `pivpn` — VPN LXC

Read-only checks:

```bash
systemctl status wg-quick@wg0 --no-pager 2>/dev/null || true
systemctl status openvpn --no-pager 2>/dev/null || true
wg show 2>/dev/null || sudo -n wg show 2>/dev/null || true
journalctl -u wg-quick@wg0 --since '24 hours ago' --no-pager -n 200 2>/dev/null || true
```

Risk markers:

- VPN service down
- peers stale beyond expected usage window
- high handshake failures
- firewall/NAT errors

#### `zabbix` — monitoring host

Read-only checks:

```bash
systemctl status zabbix-server --no-pager 2>/dev/null || true
systemctl status zabbix-agent zabbix-agent2 --no-pager 2>/dev/null || true
journalctl -u zabbix-server --since '24 hours ago' --no-pager -n 200 2>/dev/null || sudo -n journalctl -u zabbix-server --since '24 hours ago' --no-pager -n 200 2>/dev/null || true
```

Risk markers:

- Zabbix server down
- database backlog
- unsupported items explosion
- monitoring host not seeing other infrastructure

#### `security-onion` — security monitoring

Read-only checks:

```bash
systemctl --failed --no-pager 2>/dev/null || true
sudo -n so-status 2>/dev/null || true
journalctl --since '24 hours ago' --no-pager -p warning..alert -n 300 2>/dev/null || true
```

Risk markers:

- Security Onion services degraded
- sensor capture errors
- disk pressure on packet/log storage
- ingest pipeline failures

#### `github-runner-01` — GitHub runner host

First classify and add to inventory if Pedro approves.

Read-only checks:

```bash
systemctl --failed --no-pager 2>/dev/null || true
systemctl status actions.runner* --no-pager 2>/dev/null || true
journalctl -u 'actions.runner*' --since '24 hours ago' --no-pager -n 200 2>/dev/null || true
ps -eo pid,ppid,stat,%cpu,%mem,etime,comm,args --sort=-%cpu | head -25
```

Risk markers:

- runner offline
- stuck build processes
- workspace disk pressure
- frequent job failures

#### `mcp-behemoth` — MCP/Hermes host

Read-only checks:

```bash
systemctl --failed --no-pager 2>/dev/null || true
ps -eo pid,ppid,stat,%cpu,%mem,etime,comm,args --sort=-%cpu | head -40
journalctl --since '24 hours ago' --no-pager -p warning..alert -n 300 2>/dev/null || true
command -v docker >/dev/null && docker ps --format '{{json .}}' || true
```

Risk markers:

- Hermes/OpenClaw/MCP gateway process failures
- memory pressure
- container restarts
- plugin/auth errors in logs

### Phase 5 — Report Format

Each run should produce:

```text
~/.hermes/health-checks/reports/YYYY-MM-DD_HHMMSS/
├── summary.md
├── results.json
├── hosts/
│   ├── <alias>.md
│   └── <alias>.json
└── raw/
    └── <alias>/
        ├── command-index.json
        └── sanitized-output.txt
```

`summary.md` should begin with:

```markdown
# Fleet Health Check Summary

Run: YYYY-MM-DD HH:MM TZ
Hosts checked: N/N
Critical: N
Warnings: N
Unknown: N

## Critical
- [alias] finding — evidence

## Warnings
- [alias] finding — evidence

## Host Matrix
| Host | Role | Reachable | Systemd | Disk | Memory | Logs | Containers | Role Check |
|---|---|---:|---|---|---|---|---|---|
```

Severity rules:

- `critical`: service down, storage >= 90%, data integrity issues, DNS/VPN/monitoring unavailable, container repeatedly restarting, security monitoring degraded.
- `warning`: storage >= 80%, degraded but non-critical service, recurring app errors, high resource pressure, stale inventory, missing permissions.
- `info`: version drift, disabled optional services, logs unavailable due to permissions.
- `ok`: check completed with no concerning findings.
- `unknown`: host unreachable or command unavailable.

### Phase 6 — Pilot Run Plan

After Pedro approves execution:

1. Run inventory-only diff locally.
2. Run safe SSH reachability probe for every alias:

   ```bash
   ssh -o BatchMode=yes -o ConnectTimeout=10 <alias> 'hostname && uname -srm'
   ```

3. Run universal probes against one low-risk host first, likely `cockpit-server` or another Pedro-approved LXC.
4. Review report quality and redaction.
5. Expand to role-specific probes for the same host.
6. Run full fleet health check.
7. Review findings with Pedro before any remediation.

### Phase 7 — Repeatable Skill Creation

Only after one successful pilot, create a Hermes skill.

Candidate skill:

- Name: `infrastructure-health-checks`
- Category: `devops`
- Path: `~/.hermes/profiles/devopsbuddy/skills/devops/infrastructure-health-checks/`

Skill contents:

```text
infrastructure-health-checks/
├── SKILL.md
├── scripts/
│   ├── fleet_health_check.py
│   └── redact_health_output.py
└── references/
    ├── probe-catalog.md
    ├── severity-rules.md
    └── report-format.md
```

Skill trigger description should mention:

- fleet health checks
- `~/.ssh/config`
- server inventory
- processes/logs/containers/systemd/storage/network checks
- read-only infrastructure audit
- repeatable report generation

Skill behavior:

1. Load host aliases from `~/.ssh/config`.
2. Merge `~/.hermes/server-inventory.yaml` roles/policies.
3. Ask before any remote execution unless user already granted scope.
4. Run read-only probes.
5. Generate sanitized report.
6. Never remediate without separate explicit approval.

### Phase 8 — Optional Cron Automation Later

Do not schedule until manual runs are stable.

If Pedro wants automation later:

- Daily lightweight health check: reachability, failed units, disk, container restarts.
- Weekly deep health check: logs, role-specific checks, backup evidence, version drift.
- Delivery: Telegram summary only, with detailed artifacts local.
- Stale-job detection: alert if the cron report fails to generate.

Cron prompt must be self-contained and must not recursively schedule cron jobs.

## Files Likely To Change During Implementation

Implementation phase, not plan mode:

- `~/.hermes/server-inventory.yaml`
  - Add or classify `github-runner-01` if approved.
  - Possibly classify `cardinal-media-server`.
- `~/.hermes/health-checks/config.yaml`
  - Role-specific check config and thresholds.
- `~/.hermes/health-checks/scripts/fleet_health_check.py`
  - Main read-only probe runner.
- `~/.hermes/health-checks/scripts/redact_health_output.py`
  - Sanitization helper.
- `~/.hermes/health-checks/reports/...`
  - Generated reports.
- `~/.hermes/profiles/devopsbuddy/skills/devops/infrastructure-health-checks/SKILL.md`
  - Created only after pilot succeeds and Pedro approves skill creation.
- Optional skill resources under:
  - `references/probe-catalog.md`
  - `references/severity-rules.md`
  - `references/report-format.md`
  - `scripts/fleet_health_check.py`

## Tests / Validation

Local validation for scripts:

```bash
python3 -m py_compile ~/.hermes/health-checks/scripts/fleet_health_check.py
python3 ~/.hermes/health-checks/scripts/fleet_health_check.py --inventory-only --dry-run
python3 ~/.hermes/health-checks/scripts/fleet_health_check.py --host <alias> --dry-run
```

Redaction tests:

```bash
python3 ~/.hermes/health-checks/scripts/redact_health_output.py < sample-sensitive-log.txt
```

Expected redaction coverage:

- `Authorization: Bearer ...`
- API keys
- passwords
- cookies
- connection strings
- private header values
- tokens in URLs

Pilot validation:

```bash
python3 ~/.hermes/health-checks/scripts/fleet_health_check.py --host <approved-low-risk-host> --output ~/.hermes/health-checks/reports/test-run
```

Full-fleet validation after pilot:

```bash
python3 ~/.hermes/health-checks/scripts/fleet_health_check.py --all --output ~/.hermes/health-checks/reports/$(date +%Y-%m-%d_%H%M%S)
```

Skill validation after creation:

- Run `skill_view("infrastructure-health-checks")` and confirm instructions are compact and actionable.
- Run a trigger sanity check with prompts like:
  - “Check the health of my infrastructure from ssh config.”
  - “Run process/log/container checks on all servers.”
  - “Generate my weekly fleet health report.”
- Confirm near-miss prompts do not trigger unnecessary remote probing.

## Risks, Tradeoffs, And Open Questions

### Risks

- Some checks may require `sudo`; using `sudo -n` avoids prompts but may leave gaps.
- Logs can leak secrets; redaction must run before summaries are sent anywhere.
- Service names differ by distro/container image; probe runner must tolerate missing commands.
- Security Onion and Proxmox checks can be noisy; severity rules need tuning after first run.
- “Full coverage” can become huge; the report must summarize first and keep raw detail separate.

### Tradeoffs

- Read-only SSH checks are safer than agent installation but less continuous than Zabbix/native monitoring.
- A Python runner is more maintainable than ad hoc shell loops, but it takes one implementation pass to build well.
- Role-aware checks are more useful than generic checks, but require accurate inventory roles.

### Open Questions For Pedro

1. Should `github-runner-01` be added to `~/.hermes/server-inventory.yaml`?
2. What is the role/touch policy for `cardinal-media-server`?
3. May the health checker use `sudo -n` for read-only commands?
4. Should reports remain local only, or should summary reports be sent to Telegram?
5. Are any hosts off-limits for deep log inspection?
6. Do you want the first pilot on a low-risk LXC before full-fleet probing?

## Recommended First Execution Slice

When Pedro approves execution, start small:

1. Inventory reconciliation only.
2. Add missing `github-runner-01` to inventory if approved.
3. Reachability probe all aliases.
4. Run full universal checks on one approved low-risk host.
5. Review sanitized report with Pedro.
6. Expand to all hosts.
7. Build the repeatable skill from the proven workflow.
