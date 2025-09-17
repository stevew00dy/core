# Claude Code Startup Script

## Commands to run on startup:

1. **Setup core container (if not running):**
   ```bash
   docker ps | grep core || docker run -d --name core ubuntu:latest sleep infinity
   ```

2. **Start MCP gateway:**
   ```bash
   docker mcp gateway run
   ```

## Notes:
- Check if core container exists before creating
- MCP gateway provides GitHub tools via MCP Toolkit
- Gateway runs in stdio mode and watches for config updates
- Always run these commands at the start of each session