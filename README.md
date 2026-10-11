# faber-attest-sandbox

**A throwaway test sandbox. Nothing here is a product; do not use or depend on it.**

It exists to test a release design end to end on GitHub: a `workflow_dispatch`
release that builds a hello-world binary on GitHub-hosted runners, checksums it,
attests `SHA256SUMS` with GitHub's keyless build provenance, and leaves a
**draft** release that only the repository owner publishes. The `v*` tag
ruleset and branch rules are declared in `infra/` with the GitHub Terraform
provider.

The releases here are test fixtures. The repository will be deleted when the
test is over.

Releases v0.0.1 and v0.0.2 exist so replay tests have an older genuine build.
