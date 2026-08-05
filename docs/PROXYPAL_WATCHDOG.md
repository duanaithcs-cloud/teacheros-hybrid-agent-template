# ProxyPal Watchdog

ProxyPal can occasionally stop or lose its active runtime route after app restarts. The watchdog keeps the TeacherOS bridge alive without relying on the desktop UI.

## Install

Run once on Windows:

```bat
scripts\install-proxypal-watchdog.bat
```

This creates a Windows Scheduled Task:

```text
TeacherOS_ProxyPal_Watchdog
```

The task runs every minute and calls:

```text
scripts\run-watchdog-hidden.vbs
```

The VBS runner starts `scripts\watchdog-proxypal.ps1` with a hidden window so the desktop does not flash every minute.

## What It Checks

- `cli-proxy-api.exe` is running.
- ProxyPal answers `GET http://127.0.0.1:8317/v1/models`.
- `config/proxypal.local.yaml` still contains model aliases such as `gemini-3-flash-claude`.

## What It Repairs

If the bridge is down, the watchdog restarts ProxyPal CLI with the project-owned local config:

```text
config/proxypal.local.yaml
```

It does not print or upload API keys.

It only restarts `cli-proxy-api.exe`; it does not close the ProxyPal desktop UI.

The daily `teacheros` launcher uses the same stable bridge rule through:

```text
scripts/start-proxypal-stable.ps1
```

That starter reuses the running bridge when it is healthy. If repair is needed, it restarts only `cli-proxy-api.exe` in a hidden window and leaves the ProxyPal desktop UI open.

## Logs

Logs are written to:

```text
logs/proxypal-watchdog.log
```
