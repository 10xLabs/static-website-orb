# Static Website Orb Source

This orb provides reusable CI/CD components for building and deploying static websites using CircleCI. The orb is authored in _unpacked_ form and automatically packed, tested, and published via the `.circleci/config.yml` configuration.

## Structure

### @orb.yml

The entry point for the orb, defining:
- **version**: 2.1 (orb-compatible configuration)
- **description**: "Deploy static website"
- **display**: Links to homepage and source repository
- **orbs**: Dependencies (aws-cli@2.0.2)

### executors/

Defines execution environments:
- **node.yml**: Node.js Docker executor (cimg/node:18.13.0) with configurable tag parameter

### commands/

Reusable commands that compose shell scripts:

| Command | Purpose |
|---------|---------|
| **install** | Install npm dependencies with GitHub Package Registry support |
| **build** | Build static site and set RELEASE environment variable |
| **test** | Run test suite |
| **deploy** | Deploy via Pulumi with workspace attachment |
| **lint-commits** | Validate conventional commits format |
| **prepare-release** | Calculate semantic version and create release PR |
| **release** | Create GitHub release with automated notes |

### jobs/

Complete job definitions that compose commands:

| Job | Steps |
|-----|-------|
| **build** | checkout → install → build |
| **test** | checkout → install → test |
| **deploy** | checkout → deploy (attaches workspace) |
| **lint-commits** | Validates commit message conventions |
| **prepare-release** | Generates release pull requests |
| **release** | Creates final GitHub releases |

### scripts/

Bash implementation scripts included via `<< include(file) >>`:

**Installation Scripts:**
- `install_aws_cli.sh`, `install_pulumi.sh`, `install_github_cli.sh`
- `install_dependencies.sh`, `install_commit_linter.sh`

**Build & Test:**
- `build.sh`, `test.sh`

**Deployment:**
- `pulumi_update.sh`, `set_stack_name.sh`, `deploy.sh`

**Release Management:**
- `calculate_release_version.sh` - Implements semantic versioning logic
- `get_release_type.sh` - Determines MAJOR/MINOR/PATCH from conventional commits
- `create_release.sh`, `tag_jira_issues.sh`, `prepare_release.sh`

**Utilities:**
- `set_parameters.sh`, `set_release.sh`, `configure_commit_linter.sh`

### examples/

Usage examples for the orb documentation.

### tests/

BATS (Bash Automated Testing System) test files.

## Semantic Versioning

The orb implements automatic semantic versioning based on conventional commits:

- **PATCH** (`fix:`) - Bug fixes
- **MINOR** (`feat:`) - New features
- **MAJOR** (`feat!:` or `fix!:`) - Breaking changes

Version calculation analyzes commits between `master` and `develop` branches.

## Development

Scripts are validated with shellcheck (excluding SC2148) and tested with BATS before publication. The orb is automatically published to `nexbus/static-website` when version tags are pushed.

## Resources

- [Orb Author Intro](https://circleci.com/docs/2.0/orb-author-intro/#section=configuration)
- [Reusable Configuration](https://circleci.com/docs/2.0/reusing-config)
- [Orb Registry Page](https://circleci.com/orbs/registry/orb/nexbus/static-website)