# VoiceMode MCP Setup

VoiceMode provides two-way voice communication with Claude Code using local
Whisper (STT) and Kokoro (TTS) services running on-device via Apple Silicon.

## Installation

1. Install the plugin:
   ```
   claude plugin marketplace add mbailey/voicemode
   claude plugin install voicemode@voicemode
   ```

2. Install local voice services (downloads ~2-4GB of models):
   ```
   uvx voice-mode-install
   ```
   Select "Y" when prompted to install local services.

3. System dependencies (`portaudio` and `ffmpeg`) are provided via Nix in
   `modules/home/cli.nix`.

## Nix + launchd PATH Fix

VoiceMode installs launchd agents to auto-start Whisper and Kokoro:
- `~/Library/LaunchAgents/com.voicemode.whisper.plist`
- `~/Library/LaunchAgents/com.voicemode.kokoro.plist`

These plists do not include the Nix profile path, so the services fail to find
`ffmpeg` and `uv`. The fix is to prepend `/etc/profiles/per-user/bryce/bin` to
the `PATH` in both plist files:

```xml
<key>PATH</key>
<string>/etc/profiles/per-user/bryce/bin:/Users/bryce/.local/bin:/usr/local/bin:...</string>
```

Then reload:
```
launchctl unload ~/Library/LaunchAgents/com.voicemode.whisper.plist
launchctl load ~/Library/LaunchAgents/com.voicemode.whisper.plist
launchctl unload ~/Library/LaunchAgents/com.voicemode.kokoro.plist
launchctl load ~/Library/LaunchAgents/com.voicemode.kokoro.plist
```

**This fix may need to be reapplied after VoiceMode plugin updates**, as the
plists can be regenerated without the Nix path.

## Configuration

Config file: `~/.voicemode/voicemode.env`

Key settings for local-only operation:
```
VOICEMODE_STT_BASE_URLS=http://127.0.0.1:2022/v1
VOICEMODE_PREFER_LOCAL=true
VOICEMODE_ALWAYS_TRY_LOCAL=true
VOICEMODE_AUTO_START_KOKORO=true
```

These can be set via:
```
uvx voice-mode config set KEY value
```

## Service Management

```
uvx voice-mode service status
uvx voice-mode service start whisper
uvx voice-mode service start kokoro
uvx voice-mode service logs whisper
uvx voice-mode service logs kokoro
```

## Troubleshooting

- If STT shows `openai` instead of `whisper`, the local Whisper server isn't
  reachable. Check `uvx voice-mode service status` and the error logs.
- If services crash in a loop, check the error logs at
  `~/.voicemode/logs/{whisper,kokoro}/*.err.log` — usually a missing binary
  on PATH (the Nix issue above).
- Multiple whisper-server processes can conflict on port 2022. Kill all with
  `pkill -f whisper-server` and let launchd restart a clean instance.
- Claude Code must be restarted after config changes for the MCP server to
  pick up new settings.

## Recording Chime Patch

The default recording start/stop chime is generated programmatically in
`~/.local/share/uv/tools/voice-mode/lib/python3.12/site-packages/voice_mode/core.py`
using sine waves at 800/1000Hz, which sounds harsh. The frequencies were lowered
to 400/500Hz in `play_chime_start` and `play_chime_end` for a softer tone.

**This patch will be overwritten when VoiceMode is updated.** There is no config
option to change the chime frequencies — consider filing a feature request
upstream if this becomes tedious to maintain.

## Future Improvement

The launchd plist PATH issue could be permanently solved by managing the plists
through nix-darwin's `launchd.user.agents`, but this would mean taking ownership
away from VoiceMode's installer.
