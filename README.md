# faber-attest-sandbox

**A throwaway test sandbox. Nothing here is a product; do not use or depend on it.**

It exists to test a release design end to end on GitHub: a `workflow_dispatch`
release that builds on GitHub-hosted runners, checksums the assets, attests
`SHA256SUMS` with GitHub's keyless build provenance, and leaves a **draft**
release that only the repository owner publishes. The `v*` tag ruleset and
branch rules are declared in `infra/` with the GitHub Terraform provider.

What it builds is a **stand-in** (`src/main.rs`), not a real program: it prints
`faber <version>+g<commit>` for `--version`, accepts `check-config`, and refuses
everything else. Its "app" asset is a tarball holding only a `VERSION` file.

- `.github/workflows/release.yml` is a port of a real release workflow, with
  only the build swapped for the stand-in; its header lists every change.
- `.github/workflows/other.yml` is a second workflow that attests the same
  assets, so tests can show a release attested by the wrong workflow is refused.
- `.github/workflows/orphan-tags.yml` fails on any `v*` tag without a published
  release.
- `.github/workflows/proof7.yml` probes what a workflow token can do to releases.

The releases here are test fixtures. Some are deliberately bad (a tampered
`SHA256SUMS`, a tag on the wrong commit, an old build under a new tag) and are
named so in their notes. The repository will be deleted when the test is over.
