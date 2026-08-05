# Troubleshooting

| Symptom | Root cause | Fast fix |
|---|---|---|
| `502 unknown provider` | ProxyPal bridge is not running on port `8317`. | Run `0_Start_TeacherOS.bat` again. |
| `401 Unauthorized` | Missing ProxyPal local token. | Use token `proxypal-local` in local tests. |
| `404 NotFound` from Google | Wrong upstream model ID. | Use model IDs like `gemini-3-flash-preview` or update aliases in local config. |
| `429 Quota Exceeded` | Google free tier rate limit reached. | Wait, reduce request volume, or add another personal API key. |
| Cursor says `You've hit your usage limit` | Request is going through Cursor built-in models. | Use Claude Code Terminal route, not Cursor `Auto` or built-in models. |
| Vietnamese text is broken | File encoding or mojibake issue. | Save as UTF-8 No BOM and fix broken text before continuing. |

## Status Check

Run:

```bat
1_Check_Status.bat
```

Expected result:

- ProxyPal process is running.
- `GET /v1/models` returns HTTP 200 with token `proxypal-local`.
- Config contains Gemini aliases.

