# Hybrid Runtime Analysis

This document explains the TeacherOS Hybrid Agent workflow that the template packages.

## Running Layers

```text
Teacher command
  -> 0_Start_TeacherOS.bat or teacheros
  -> ProxyPal local bridge on 127.0.0.1:8317
  -> Claude Code CLI environment variables
  -> Google AI Studio Gemini model
  -> generated lesson-plan products
```

## Files That Matter

| File | Role |
|---|---|
| `0_Start_TeacherOS.bat` | One-click daily launcher. |
| `scripts/start-teacheros.bat` | Starts ProxyPal, exports Claude Code route variables, then launches Claude Code. |
| `scripts/setup.bat` | First-time setup; asks for the user's Google AI Studio API key and generates ignored local config. |
| `scripts/check-status.ps1` | Checks whether ProxyPal is running and reachable. |
| `config/proxypal.config.example.yaml` | Public example config with model aliases and no real key. |
| `config/proxypal.local.yaml` | Local generated config; ignored by Git. |
| `.cursor/.cursorrules` | Pedagogical and coding rules for lesson-plan work. |

## AI Connections

Cursor is the editing and terminal environment. It should not be the paid model route for heavy work.

Claude Code CLI is the agent interface. The launcher sets:

```text
ANTHROPIC_AUTH_TOKEN=proxypal-local
ANTHROPIC_BASE_URL=http://127.0.0.1:8317
ANTHROPIC_MODEL=gemini-3-flash-claude
```

ProxyPal acts as the OpenAI/Anthropic-compatible bridge and maps:

```text
gemini-3-flash-claude -> gemini-3-flash-preview
gemini-3-flash        -> gemini-3-flash-preview
```

Google AI Studio receives the upstream Gemini request using the teacher's own API key.

## Products This System Can Create

- Vietnamese lesson plans following GDPT 2018 and Cong van 5512.
- Lesson worksheets and answer keys.
- Consolidation and review questions.
- Digital competence tasks for classroom use.
- DOCX lesson-plan files with `python-docx`.
- PPTX slide decks with `python-pptx`.
- Local Streamlit classroom apps.
- Supporting tables, rubrics, and appendices.

## Stability Rule

Do not rely on a ProxyPal desktop UI state as the only source of truth. Use a project-owned local config generated from the template so the model aliases remain stable after reset.

