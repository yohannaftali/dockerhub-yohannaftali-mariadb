# CHANGE_HISTORY.md

Newest first. One dated entry per notable change.

## [2026-10-05] — chore: freeze legacy duplicate Docker Hub repos
- `yohannaftali/yohannaftali-mariadb` duplicate `yohannaftali/mariadb` and are still pulled by other apps. Added a DEPRECATED overview and short description to each (images untouched, no new pushes) and recorded the policy in `AGENTS.md`. Docker Hub's "Archive repository" setting (web UI) can additionally block pushes.

## [2026-10-05] — chore: agent guide and skills
- Added `AGENTS.md`, `CLAUDE.md`, `CHANGE_HISTORY.md` and `.claude/skills/` (`planner`, `coder`, `tester`, `reviewer`), adapted from the Senar project for this single-image repo (GitHub + `gh`, local Docker smoke test instead of browser testing).
- Files: `AGENTS.md`, `CLAUDE.md`, `CHANGE_HISTORY.md`, `.claude/skills/*/SKILL.md`

## [2026-10-05] — feat: Docker Hub maintenance script
- `scripts/dockerhub_update.py` (stdlib, run via `uv`) with `sync` / `status` / `tags` / `delete-tag`, plus `dockerhub-update.sh` and `.ps1` wrappers. Documented in README "Maintenance scripts".
- Verified `tags` and `sync` live against Docker Hub. Categories confirmed set manually (*Developer tools*, *Databases & storage*); the API ignores `categories` on PATCH.

## [2026-10-05] — feat: automated publishing and complete README
- `Dockerfile`: `MARIADB_VERSION` build arg, OCI labels, `ENV TZ=Asia/Jakarta` (current syntax), trailing newline.
- `.github/workflows/docker-publish.yml`: matrix `latest`/`11.4`/`10.11`, amd64+arm64, weekly + on push + manual, then syncs README to the Hub overview.
- Added `.env.example`, `.gitignore` (`.env`), rewrote `README.md` (overview, tags, quick start, compose, build, maintenance).
- Repo secrets `DOCKERHUB_USERNAME` / `DOCKERHUB_TOKEN` set; first run failed (secrets missing), rerun passed.

## [2023-04-10] — docs: initial README
- Minimal README with manual build/tag/push steps.

## [2023-03-07] — fix: Dockerfile error
- Fixed the timezone `RUN` line after the Aria plugin change.

## [2023-03-06] — chore: add plugin-aria
- Dockerfile change for the Aria plugin.

## [2021-10-05] — initial commit
- `Dockerfile`: `FROM mariadb:latest`, `TZ=Asia/Jakarta`.
