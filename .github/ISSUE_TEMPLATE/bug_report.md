---
name: "Bug Report"
about: "Report a confirmed bug or regression in the Void OS engine"
title: "[BUG] "
labels: ["bug", "needs triage"]
assignees: []
---

## Pre-Flight Checklist

Before submitting, confirm ALL of the following:

- [ ] I am running a **clean, freshly installed** copy of Windows 11 (not upgraded)
- [ ] I installed Void OS using the latest `.apbx` release from the [Releases](https://github.com/v0idOS/Void-OS/releases) page
- [ ] I have checked the [Known Issues](https://github.com/v0idOS/Void-OS/blob/main/docs/known_issues.md) document and this is not listed
- [ ] I have checked [existing issues](https://github.com/v0idOS/Void-OS/issues) and this has not been reported

---

## System Telemetry

> **Required.** Run the Void Control Center (`VoidControlCenter.exe` on your desktop) and paste the System Topology and Engine Status panel data here. Without this, the issue will be closed.

```
CPU:
Architecture:
RAM:
GPU:
Chassis:
Engine Status (Applied/Not Applied for each module):
```

---

## Describe the Bug

**What happened:**

**What you expected to happen:**

**Steps to reproduce:**
1. 
2. 
3. 

---

## Log Output

Paste the relevant lines from `C:\VoidOS_Logs\Optimization_<date>.log`:

```
[paste log lines here]
```

---

## LatencyMon / CapFrameX Data (if performance-related)

| Metric | Before | After |
|--------|--------|-------|
| Avg DPC (μs) | | |
| Worst Spike (μs) | | |
| Offending Driver | | |

---

## Additional Context

Any other relevant information (screenshots, crash dumps, Event Viewer entries).
