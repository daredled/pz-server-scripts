# pz-server-scripts

Windows batch scripts for running and updating a Project Zomboid dedicated server hosted at `C:\pzserver` (Build 41) / `C:\pzserverb42` (Build 42 unstable), using SteamCMD at `C:\steamcmd`.

SteamCMD installation and app updates are handled by the shared
[steamcmd-server-scripts](https://github.com/daredled/steamcmd-server-scripts)
repo, checked out here as the `common/` git submodule.

## Setup

Clone with submodules:

```
git clone --recurse-submodules https://github.com/daredled/pz-server-scripts.git
```

If already cloned without that flag: `git submodule update --init`.

Set your Steam account username as an environment variable before running `pz_server_install.bat` (never hardcoded in the scripts):

```
set STEAM_USER=yourSteamAccount
```

Use `setx STEAM_USER yourSteamAccount` instead if you want it to persist across cmd sessions.

## Scripts

### `pz_server_run.bat`
Starts the dedicated server.

- `pz_server_run.bat` — runs Build 41 from `C:\pzserver`, save name `servertest`.
- `pz_server_run.bat b42` — runs Build 42 from `C:\pzserverb42`, save name `pzb42` (kept separate from the B41 `servertest` save on purpose — see Notes).

Refuses to start if a Project Zomboid `java.exe` process already appears to be running, or if `StartServer64.bat` isn't found in the target install folder.

### `pz_server_install.bat`
Updates/installs the server via SteamCMD. Requires the `STEAM_USER` env var (see Setup). Installs `steamcmd` automatically via `common/steamcmd_install.bat` if it isn't present yet.

Optional arguments, in any order:

- `verify` — adds SteamCMD's `validate` flag (full file checksum verification; slower).
- `b42` — switches to the Build 42 unstable branch (`-beta unstable`) and installs to `C:\pzserverb42` instead of `C:\pzserver`.

Examples:
```
pz_server_install.bat
pz_server_install.bat verify
pz_server_install.bat b42
pz_server_install.bat b42 verify
```

Refuses to run if a Project Zomboid `java.exe` process already appears to be running.

### `common/steamcmd_install.bat` and `common/steam_app_install.bat`
Shared scripts from the `steamcmd-server-scripts` submodule. Called automatically by `pz_server_install.bat`; you normally don't need to run them directly. See that repo's README for details.

## Notes

- **steamcmd exit codes are unreliable.** `steamcmd.exe +quit` routinely returns a non-zero exit code even after a fully successful run (a known steamcmd quirk). The scripts don't treat that as a hard failure — check the printed output / `C:\steamcmd\logs` if you want to confirm a run actually succeeded.
- **B41 and B42 share the same `%USERPROFILE%\Zomboid` data folder.** Both installs write saves/config there by default. To avoid Build 42 loading (and crashing on) the Build 41 `servertest` save, `pz_server_run.bat b42` passes `-servername pzb42` so Build 42 gets its own save under `Saves\Multiplayer\pzb42`.
- Build 42 is on the unstable branch and updates can break saves without warning — back up `Zomboid\Server` and `Zomboid\Saves` before running `pz_server_install.bat b42`.
