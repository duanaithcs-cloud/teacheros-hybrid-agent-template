# TeacherOS Hybrid Agent Template

**Cursor UX + Claude Code CLI + ProxyPal + Gemini Flash for teachers and EdTech creators.**

This repository packages a tested local workflow for building Vietnamese lesson plans, teaching materials, DOCX/PPTX files, and small classroom apps with an OpenAI-compatible local proxy.

The goal is simple: a teacher can clone this project, run one setup script, paste their own Google AI Studio API key, and work from Cursor Terminal without spending Cursor Agent quota.

## What This Template Does

- Starts a local ProxyPal bridge at `http://127.0.0.1:8317/v1`.
- Routes Claude Code CLI requests through ProxyPal.
- Uses Gemini model aliases such as `gemini-3-flash-claude`.
- Keeps API keys in ignored local files, never in Git.
- Gives Cursor project rules for Vietnamese UTF-8, GDPT 2018, lesson plans, DOCX, PPTX, and Streamlit classroom apps.

## Quick Start

1. Clone the repo:

```bash
git clone https://github.com/YOUR-USERNAME/teacheros-hybrid-agent-template.git
cd teacheros-hybrid-agent-template
```

2. Run setup on Windows:

```bat
scripts\setup.bat
```

Then paste your Google AI Studio API key when prompted.

3. Start daily work:

```bat
0_Start_TeacherOS.bat
```

Open this folder in Cursor, use the terminal route, and ask Claude Code to create lesson plans, worksheets, Streamlit classroom apps, DOCX, or PPTX outputs.

Optional one-word command:

```bat
scripts\install-teacheros-command.bat
teacheros
```

Optional ProxyPal watchdog:

```bat
scripts\install-proxypal-watchdog.bat
```

If Google returns `429 All credentials`, stop retry loops and use lite mode:

```bat
teacheros-reset
teacheros-lite
```

## Important Cursor Note

To avoid Cursor Free usage limits, do not use built-in Cursor models such as `Cursor Grok`, `Cursor Claude`, `Cursor GPT`, or `Auto` for heavy agent work.

Use Claude Code CLI in Cursor Terminal through this template:

```bat
0_Start_TeacherOS.bat
```

## Google AI Studio Key

Get a free API key from:

https://aistudio.google.com/app/apikey

Paste the key only into `scripts\setup.bat` when prompted. The setup script writes it into `config/local.env` and `config/proxypal.local.yaml`, both ignored by Git.

## Model Routing

| User-facing route | ProxyPal alias | Upstream model |
|---|---|---|
| Claude Code CLI | `gemini-3-flash-claude` | `gemini-3-flash-preview` |
| Cursor custom model | `gemini-3-flash` | `gemini-3-flash-preview` |
| Fallback fast model | `gemini-2.5-flash` | `gemini-2.5-flash` |

Google can change model availability. If one model returns `404`, keep the alias and switch the upstream model in `config/proxypal.local.yaml`.

## Folder Map

```text
.
+-- .cursor/
|   +-- .cursorrules
+-- config/
|   +-- proxypal.config.example.yaml
|   +-- claude-code.env.example
+-- docs/
|   +-- ARCHITECTURE.md
|   +-- WORKFLOW_TESTED.md
|   +-- HYBRID_RUNTIME_ANALYSIS.md
|   +-- TEACHEROS_COMMAND.md
|   +-- PROXYPAL_WATCHDOG.md
|   +-- QUOTA_429_PLAYBOOK.md
+-- scripts/
|   +-- setup.bat
|   +-- start-teacheros.bat
|   +-- install-teacheros-command.bat
|   +-- install-proxypal-watchdog.bat
|   +-- watchdog-proxypal.ps1
|   +-- check-status.ps1
|   +-- restore-proxypal-config.ps1
+-- templates/
|   +-- lesson_plans/
|   +-- pptx_builder/
+-- 0_Start_TeacherOS.bat
+-- 1_Check_Status.bat
+-- 2_Open_Cursor_Project.bat
+-- START_HERE.md
+-- TROUBLESHOOTING.md
```

## Performance Expectations

| Route | Cost | Best use | Risk |
|---|---:|---|---|
| Cursor built-in Agent models | Paid/free quota | Cursor native chat UX | Can hit Cursor usage limit |
| Claude Code CLI + ProxyPal + Gemini | Google AI Studio free tier | Long EdTech coding/authoring workflows | Depends on Google free quota |
| Multiple Google API keys in ProxyPal | Free tier per key | Higher request volume | Respect Google terms and rate limits |

## Safety

- Do not commit `config/local.env`.
- Do not commit real API keys.
- Keep ProxyPal running locally on `127.0.0.1`.
- Use `1_Check_Status.bat` before a long work session.
