# Quota 429 Playbook

`429 All credentials` means the bridge is alive, but Google has rate-limited or quota-limited the available API keys for the selected model.

## What To Do

1. Stop retry loops:

```bat
teacheros-reset
```

2. Wait 2-5 minutes before sending another large prompt.

3. Use lite mode for heavy DOCX/script work:

```bat
teacheros-lite
```

4. Use smaller prompts:

```text
No subagents. No web search. Read only .cursorrules and the one DOCX sample. Write the python-docx script directly.
```

## Why This Happens

Long Claude Code tasks can send several large `/v1/messages` requests, plus title/context requests. If the task retries while all Google API keys are cooling down, every key can return 429.

## What The Template Does

- `request-retry` and `max-retry-interval` in ProxyPal config reduce immediate failures.
- `teacheros-reset` stops retry loops and restarts the ProxyPal bridge.
- `teacheros-lite` starts Claude Code in bare mode to reduce extra request overhead.
- The watchdog keeps the bridge alive, but it does not bypass Google quota.

## What Not To Do

- Do not keep pressing Enter on the same failing prompt.
- Do not run multiple Claude Code terminals on the same model at once.
- Do not switch back to Cursor built-in `Auto` model if the goal is to avoid Cursor quota.

