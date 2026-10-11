# Throwaway sandbox. Declares the repository and the rules ADR-style release
# design depends on. State stays local and is never committed.

resource "github_repository" "sandbox" {
  name        = "faber-attest-sandbox"
  description = "Throwaway test sandbox for keyless release attestation. Not a product."
  visibility  = "public"

  has_issues   = false
  has_projects = false
  has_wiki     = false

  allow_merge_commit     = false
  allow_rebase_merge     = false
  allow_squash_merge     = true
  delete_branch_on_merge = true

  # Never let `terraform destroy` delete it; the owner deletes it by hand.
  archive_on_destroy = true

  # NOT expressible in provider 6.13: immutable releases. Set by hand, see README.
}

# The default workflow token is read-only; workflows widen it per job.
resource "github_workflow_repository_permissions" "sandbox" {
  repository                       = github_repository.sandbox.name
  default_workflow_permissions     = "read"
  can_approve_pull_request_reviews = false
}

# Only GitHub-authored actions may run (all this repo uses).
resource "github_actions_repository_permissions" "sandbox" {
  repository      = github_repository.sandbox.name
  allowed_actions = "selected"
  allowed_actions_config {
    github_owned_allowed = true
    verified_allowed     = false
    patterns_allowed     = []
  }
}

# v* tags: created only by the owner, never moved or deleted.
resource "github_repository_ruleset" "release_tags" {
  name        = "release-tags"
  repository  = github_repository.sandbox.name
  target      = "tag"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["refs/tags/v*"]
      exclude = []
    }
  }

  rules {
    creation         = true
    update           = true
    deletion         = true
    non_fast_forward = true
  }

  # Repository admin (role id 5) = the owner on a user-owned repo.
  bypass_actors {
    actor_type  = "RepositoryRole"
    actor_id    = 5
    bypass_mode = "always"
  }
}

# main: PR required, no force-push, no deletion.
# SPIKE RELAXATION: the admin bypass lets the owner push to main directly to set
# the sandbox up. ADR-0031's real repo would not need it (bypass_mode
# "pull_request" or no bypass) and would also require CI status checks.
resource "github_repository_ruleset" "main" {
  name        = "main"
  repository  = github_repository.sandbox.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  rules {
    deletion         = true
    non_fast_forward = true
    pull_request {
      required_approving_review_count = 0
    }
  }

  bypass_actors {
    actor_type  = "RepositoryRole"
    actor_id    = 5
    bypass_mode = "always"
  }
}

output "repo_id" {
  value = github_repository.sandbox.repo_id
}
