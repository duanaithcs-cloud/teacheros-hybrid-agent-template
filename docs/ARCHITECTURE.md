# Architecture

The tested workflow keeps the stable engine separate from the user-facing control center.

```text
Cursor Terminal
  -> Claude Code CLI
  -> local OpenAI-compatible URL http://127.0.0.1:8317/v1
  -> ProxyPal
  -> Google AI Studio Gemini API
```

## Why This Shape

- Cursor remains the editor and UX layer.
- Claude Code CLI remains the coding/agent interface.
- ProxyPal owns model aliases and key rotation.
- Google AI Studio provides the free-tier Gemini endpoint.

## Stable Defaults

- Local proxy: `http://127.0.0.1:8317/v1`
- Local token: `proxypal-local`
- Claude model alias: `gemini-3-flash-claude`
- Cursor custom model alias: `gemini-3-flash`
- Upstream model: `gemini-3-flash-preview`

## What Not To Move

Do not move installed Cursor, ProxyPal, Claude Code, or user-specific runtime config into this repository. This repo is a clean template and control layer.

