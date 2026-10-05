# AGENTS.md

> **READ THIS FIRST.** Every AI agent working in this repository (Claude, Gemini, Copilot,
> Cursor, ...) must read this file before doing anything else. It is the single source of
> truth for what this project is and how to work on it. After any structural change
> (new file, new workflow, new tag, changed secret), update this file in the same change.
>
> **Compaction rule:** keep this file describing the *current* state. Put dated history in
> [`CHANGE_HISTORY.md`](CHANGE_HISTORY.md).

## Repository

- remote: https://github.com/yohannaftali/dockerhub-yohannaftali-mariadb
- platform: GitHub (use the `gh` CLI; it is already authenticated on the maintainer's machine)
- default branch: `main`
- Docker Hub image: `yohannaftali/mariadb` (https://hub.docker.com/r/yohannaftali/mariadb)

## Big Picture

A tiny repo that builds and publishes a [MariaDB](https://hub.docker.com/_/mariadb) image
with the **Asia/Jakarta** timezone preconfigured. There is no application code: the product
is the Docker Hub image and its listing (overview, short description, tags, categories).

```
Dockerfile ──► GitHub Actions (build matrix, amd64+arm64) ──► Docker Hub yohannaftali/mariadb
README.md  ──► peter-evans/dockerhub-description / scripts/dockerhub-update.sh ──► Hub overview
```

## Repository Layout

```
Dockerfile                       # FROM mariadb:${MARIADB_VERSION}; sets TZ=Asia/Jakarta
README.md                        # human docs AND the Docker Hub overview (synced as-is)
AGENTS.md / CHANGE_HISTORY.md    # agent guide / dated history
CLAUDE.md                        # points agents at this file
.env.example                     # variable names only; real .env is git-ignored
.github/workflows/docker-publish.yml   # build+push matrix, then description sync
scripts/dockerhub_update.py      # Docker Hub API helper (stdlib only, run via uv)
scripts/dockerhub-update.sh|.ps1 # bash / PowerShell wrappers around `uv run`
.claude/skills/                  # planner, coder, tester, reviewer (see below)
```

## Key Facts

- **Tags** are the `version` matrix in `docker-publish.yml`: `latest`, `11.4`, `10.11`.
  Adding or dropping a version means editing that matrix **and** the Tags table in `README.md`.
- The workflow runs on push to `main`, weekly (Mon 03:00 UTC, to pick up upstream fixes) and
  manually. The `description` job syncs `README.md` to Docker Hub after all builds pass.
- **Secrets** (GitHub repo secrets): `DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN` (Docker Hub PAT,
  scope *Read, Write, Delete*; description updates need Delete scope).
- **Categories cannot be set via the Docker Hub API** (it silently ignores them). They are set
  by hand in the web UI. Current: *Developer tools*, *Databases & storage*.
- **Legacy duplicate Docker Hub repos** (`yohannaftali/yohannaftali-mariadb`) are older names for `yohannaftali/mariadb`. Other apps still pull them, so they cannot be deleted. They are **frozen**: their overview carries a DEPRECATED notice pointing here (set 2026-10-05) and nothing may be pushed to them (a new MariaDB major version on an existing data volume can break apps). Maintain only `yohannaftali/mariadb`.
- `README.md` is published verbatim as the Hub overview: keep it self-contained, no
  repo-relative links that only work on GitHub.

## Conventions & Guardrails

- Never commit `.env` or any token. `.env.example` holds names and placeholders only.
- Never print tokens in output, logs or commit messages. Refer to them as `$TOKEN`.
- Keep the Dockerfile minimal: it only changes the timezone. Other behavior belongs to the
  upstream image; do not fork its entrypoint.
- Pinned versions go through the `MARIADB_VERSION` build arg, not separate Dockerfiles.
- Python scripts are stdlib-only and run through `uv` (`uv run scripts/dockerhub_update.py`);
  bash and PowerShell wrappers must stay thin and behave identically.
- Commit message ends with the attribution trailer configured for the session.
- Pushing to `main` publishes images to Docker Hub. Treat it as a release.

## Validation (before pushing)

```bash
docker build -t mariadb-test .
docker run --rm mariadb-test date +%Z                 # expect WIB
docker build --build-arg MARIADB_VERSION=11.4 -t mariadb-test:11.4 .
uv run scripts/dockerhub_update.py status             # needs .env; read-only
```

See the `tester` skill for the full smoke test (container actually starts and reports
Jakarta time).

## Agent Skills (`.claude/skills/`)

Adapted from the Senar project for a single-image repo (no issue-tracker UI, no browser).

- **`planner`**: create/track GitHub issues with `gh`; checks `CHANGE_HISTORY.md` for
  duplicates and keeps the Tracked Issues table below current.
- **`coder`**: implements an issue (Dockerfile, workflow, scripts, README) per these rules.
- **`tester`**: builds the image locally, smoke-tests it, and only then opens/merges a PR.
- **`reviewer`**: post-merge audit of what landed on `main` and on Docker Hub.

Flow: `planner` -> `coder` -> `tester` -> `reviewer`.

## Tracked Issues

| ID | Title | Status | Last Checked |
|----|-------|--------|--------------|

## Change Log Policy

- `AGENTS.md`: current architecture and rules only.
- `CHANGE_HISTORY.md`: one dated entry per notable change, newest first.
- Any agent making a structural change updates both files in the same change.
