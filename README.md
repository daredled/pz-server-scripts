# pz-server-scripts

Windows batch scripts for running and updating a Project Zomboid dedicated server hosted at `D:\pzserver` (Build 41) / `D:\pzserverb42` (Build 42 unstable), using SteamCMD at `D:\steamcmd`.

## Setup

Set your Steam account username as an environment variable before running `pz_server_install.bat` (never hardcoded in the scripts):

```
set steamUsername=yourSteamAccount
```

Use `setx steamUsername yourSteamAccount` instead if you want it to persist across cmd sessions.

## Scripts

### `pz_server_run.bat`
Starts the dedicated server.

- `pz_server_run.bat` — runs Build 41 from `D:\pzserver`, save name `servertest`.
- `pz_server_run.bat b42` — runs Build 42 from `D:\pzserverb42`, save name `pzb42` (kept separate from the B41 `servertest` save on purpose — see Notes).

Refuses to start if a Project Zomboid `java.exe` process already appears to be running, or if `StartServer64.bat` isn't found in the target install folder.

### `pz_server_install.bat`
Updates/installs the server via SteamCMD. Requires the `steamUsername` env var (see Setup). Installs `steamcmd` automatically via `install_steamcmd.bat` if it isn't present yet.

Optional arguments, in any order:

- `verify` — adds SteamCMD's `validate` flag (full file checksum verification; slower).
- `b42` — switches to the Build 42 unstable branch (`-beta unstable`) and installs to `D:\pzserverb42` instead of `D:\pzserver`.

Examples:
```
pz_server_install.bat
pz_server_install.bat verify
pz_server_install.bat b42
pz_server_install.bat b42 verify
```

Refuses to run if a Project Zomboid `java.exe` process already appears to be running.

### `install_steamcmd.bat`
Downloads and bootstraps SteamCMD into `D:\steamcmd` if it isn't already installed. Called automatically by `pz_server_install.bat`; you normally don't need to run it directly.

## Notes

- **steamcmd exit codes are unreliable.** `steamcmd.exe +quit` routinely returns a non-zero exit code even after a fully successful run (a known steamcmd quirk). The scripts don't treat that as a hard failure — check the printed output / `D:\steamcmd\logs` if you want to confirm a run actually succeeded.
- **B41 and B42 share the same `%USERPROFILE%\Zomboid` data folder.** Both installs write saves/config there by default. To avoid Build 42 loading (and crashing on) the Build 41 `servertest` save, `pz_server_run.bat b42` passes `-servername pzb42` so Build 42 gets its own save under `Saves\Multiplayer\pzb42`.
- Build 42 is on the unstable branch and updates can break saves without warning — back up `Zomboid\Server` and `Zomboid\Saves` before running `pz_server_install.bat b42`.
