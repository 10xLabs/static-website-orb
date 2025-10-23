# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **CircleCI Orb** (`nexbus/static-website`) that provides reusable CI/CD components for building and deploying static websites. The orb uses an "unpacked" structure where commands, jobs, executors, and scripts are organized in separate files under `src/`.

## Commands for Development

### Testing and Validation

The CircleCI pipeline automatically runs these checks:

```bash
# Lint YAML files (runs automatically via orb-tools/lint)
circleci orb validate src/@orb.yml

# Check shell scripts (runs automatically via shellcheck/check)
# Excludes SC2148 (shebang check)
shellcheck src/scripts/*.sh

# Run BATS tests (runs automatically via bats/run)
bats src/tests/
```

### Publishing Workflow

1. **Development versions** are automatically published on every commit that passes tests
2. **Production versions** are published when a git tag matching `v[0-9]+.[0-9]+.[0-9]+` is pushed
3. Publishing requires the `orb-publishing` context with CircleCI credentials

The orb is published to: `nexbus/static-website`

## Architecture and Structure

### Orb Component Hierarchy

The orb follows CircleCI's recommended unpacked structure:

- **src/@orb.yml** - Entry point defining orb metadata and dependencies (aws-cli@2.0.2)
- **src/executors/** - Execution environments (Node.js 18.13.0 Docker container)
- **src/commands/** - Reusable command definitions that wrap shell scripts
- **src/jobs/** - Complete job definitions that compose commands
- **src/scripts/** - Bash implementation scripts included via `<< include(file) >>`
- **src/examples/** - Usage examples for documentation

### Key Commands and Their Implementation

1. **install** - Installs npm dependencies with GitHub Package Registry support for `@10xLabs` scope
2. **build** - Builds static site; sets `RELEASE` env var from git commit or release tag
3. **test** - Runs test suite (implementation-specific)
4. **deploy** - Deploys via Pulumi; requires workspace attachment for build artifacts
5. **lint-commits** - Validates conventional commits format between branches
6. **prepare-release** - Calculates semantic version and creates release PR
7. **release** - Creates GitHub release with automated release notes

### Release Management System

The orb implements **semantic versioning** using conventional commits:

- **PATCH** bump: Commits starting with `fix:`
- **MINOR** bump: Commits starting with `feat:`
- **MAJOR** bump: Commits with breaking change marker (`feat!:` or `fix!:`)

Version calculation script: `src/scripts/calculate_release_version.sh`

The system analyzes commit history between `master` and `develop` branches to determine the appropriate version bump.

### Infrastructure Integration

- **Pulumi** for stack-based infrastructure deployment (stacks named after branches)
- **AWS CLI** (v2.0.2 orb) for S3 and CloudFront operations
- **GitHub CLI** for automated release management
- Build artifacts persisted in `public/` directory via CircleCI workspaces

### Environment Variable Patterns

Scripts heavily use `$BASH_ENV` for persisting variables across CircleCI steps:

```bash
echo "export VARIABLE_NAME=value" >> "$BASH_ENV"
```

Key variables set by scripts:
- `RELEASE` - Version string from git tag or commit SHA
- `STACK_NAME` - Pulumi stack name derived from branch
- `RELEASE_TYPE` - Semantic version bump type (major/minor/patch)

### Script Organization

19 utility scripts in `src/scripts/`:

**Installation:** aws-cli, pulumi, github-cli, dependencies, commit-linter
**Build & Test:** build.sh, test.sh
**Deployment:** pulumi_update.sh, set_stack_name.sh
**Release Management:** calculate_release_version.sh, get_release_type.sh, create_release.sh, tag_jira_issues.sh
**Configuration:** set_parameters.sh, configure_commit_linter.sh

## Important Conventions

### Commit Message Format

Must follow **Conventional Commits** specification:
- `feat: description` - New feature (MINOR bump)
- `fix: description` - Bug fix (PATCH bump)
- `feat!: description` - Breaking change (MAJOR bump)

Validated by `src/scripts/install_commit_linter.sh` and `src/scripts/configure_commit_linter.sh`

### Git Branch Strategy

- `master` - Production environment
- `develop` - Staging/development environment
- Stack names and release calculations depend on this branch naming

### Version Tags

Production releases require tags in format: `v[MAJOR].[MINOR].[PATCH]` (e.g., `v1.2.3`)

Pushing a tag triggers the integration test workflow and production orb publication.

### Package Registry Configuration

For private `@10xLabs` packages, the install command configures `.npmrc` with GitHub Package Registry:

```bash
@10xLabs:registry=https://npm.pkg.github.com
//npm.pkg.github.com/:_authToken=${GITHUB_PAT_TOKEN}
```

Requires `GITHUB_PAT_TOKEN` environment variable.

## Testing

Tests are located in `src/tests/` and use **BATS** (Bash Automated Testing System) v1.1.0.

Shell scripts are validated with **shellcheck** v3.2.0, excluding SC2148 (shebang requirement).

## Dependencies

Managed via **Renovate** (configured in `renovate.json`):
- orb-tools: v12.1.0
- shellcheck: v3.2.0
- bats: v1.1.0
- aws-cli orb: v2.0.2

## Publishing

To publish a new production version:

1. Ensure all changes are merged to develop
2. Create and push a git tag: `git tag v1.2.3 && git push origin v1.2.3`
3. CircleCI will automatically:
   - Run validation and tests
   - Publish dev version
   - Trigger integration tests
   - Publish production version to CircleCI Orb Registry

The orb appears at: https://circleci.com/orbs/registry/orb/nexbus/static-website
