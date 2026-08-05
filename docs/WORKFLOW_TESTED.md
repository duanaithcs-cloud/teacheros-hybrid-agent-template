# Tested Workflow Notes

This template is based on a manually tested TeacherOS workflow:

1. ProxyPal runs locally on port `8317`.
2. Claude Code CLI uses `ANTHROPIC_BASE_URL=http://127.0.0.1:8317`.
3. `gemini-3-flash-claude` maps through ProxyPal to Gemini Flash.
4. Cursor built-in Agent models are avoided for heavy work to prevent Cursor quota usage.
5. Teacher work happens inside the project folder, while the proxy bridge remains a runtime service.

## Recommended Daily Flow

1. Run `0_Start_TeacherOS.bat`.
2. Open project in Cursor.
3. Work from Cursor Terminal / Claude Code.
4. Use `1_Check_Status.bat` if the bridge appears broken.

