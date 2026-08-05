# TeacherOS Command

The tested daily command is:

```bat
teacheros
```

It is a small wrapper that enters the TeacherOS project folder and calls `0_Start_TeacherOS.bat`.

## Why This Helps

Teachers do not need to remember long paths, PowerShell `.\` rules, or the order of ProxyPal and Claude Code startup.

## Install The Command

Run once:

```bat
scripts\install-teacheros-command.bat
```

Then close old terminal tabs and open a new Cursor Terminal.

Use:

```bat
teacheros
```

## What It Starts

1. ProxyPal local bridge.
2. Model aliases for the Gemini route.
3. Claude Code CLI with the ProxyPal base URL.

