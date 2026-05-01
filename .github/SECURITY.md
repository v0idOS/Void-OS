# Security Policy

## Supported Versions

Currently, Void OS operates on a rolling release cycle targeting the latest Windows 11 builds (24H2+). We only support security patches for our latest released `.apbx` playbook.

| Version | Supported          |
| ------- | ------------------ |
| Latest  | :white_check_mark: |
| Older   | :x:                |

## Reporting a Vulnerability

Because Void OS heavily modifies Windows default security settings (e.g., Defender, UAC, VSS), users inherently accept a modified security posture in exchange for maximum performance.

However, if you discover a vulnerability in *our codebase* (e.g., privilege escalation via our custom PowerShell engine, malicious payload injection in our `.bat` files, or an exploit in our `VoidDesktop` tools), we take it extremely seriously.

1. **Do NOT open a public issue.**
2. Please email the core maintainer directly at: `[Insert Security Email Here]` (or contact us privately via Discord if no email is provided yet).
3. Provide a detailed proof of concept or execution path.

We will review the submission within 48 hours and coordinate a patch in the upcoming release.
