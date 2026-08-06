---
name: staff-code-review
description: Deep, opinionated code review of the current diff at staff-engineer rigor — correctness, architecture, security, performance, and operability, with severity-ranked findings and a clear merge verdict. Use for high-stakes or complex changes, not routine small diffs.
allowed-tools:
  - Read
  - Bash
  - Glob
---

# Staff Code Review

Review like a staff engineer signing off on a change that will page them at 3am if it's wrong: rigorous on risk, unopinionated on style, and always clear about whether this should merge.

## Process

1. **Establish real scope.**
   - If given a GitHub PR URL (`$ARGUMENTS`, e.g. `https://github.com/org/repo/pull/123`): run `gh pr view $ARGUMENTS --json title,body,baseRefName,commits,files` for context and `gh pr diff $ARGUMENTS` for the diff. Use `gh` read-only here — never `gh pr comment`, `gh pr review`, or anything else that posts to GitHub (see Guardrails).
   - Otherwise, diff the current working tree (`git diff` against the base branch) or the files given.
   Then read enough of the surrounding code — not just the changed hunks — to understand the actual blast radius: callers, related tests, config, migrations. A review that only reads the diff misses context-dependent bugs. If the project has a test suite, linter, or build, run them — don't take "it compiles" or "tests pass" on faith when you can check directly.
2. **Check for prior art first.** Before flagging something as wrong, check whether it matches an existing pattern elsewhere in the codebase, or was a deliberate tradeoff (check commit messages, PR description, comments). Don't re-litigate decisions that were made on purpose for a good reason — raise them as a question, not a blocker.
3. **Review in passes**, in this order — correctness first, because a beautifully architected change that's wrong is still wrong:
   - **Correctness** — logic errors, off-by-one, edge cases (empty/null/zero/max), error handling and failure paths, race conditions and concurrent access, resource cleanup (leaks, unclosed handles), and whether tests actually exercise the risk (not just line coverage).
   - **Architecture & design** — is complexity proportional to the problem; coupling and blast radius; is this the right abstraction level for the codebase's actual trajectory (not a hypothetical future); does it fit or fight existing patterns; is it reversible if wrong.
   - **Security** — injection (SQL/command/template), auth/authz boundaries, secrets in code or logs, unsafe deserialization, path traversal/SSRF, trust boundaries between user input and privileged operations.
   - **Performance** — algorithmic complexity on realistic input sizes, N+1 queries, unnecessary allocations or copies, blocking calls in hot/async paths.
   - **Operability** — observability for the new failure modes this introduces (logs/metrics/traces), rollback safety, backward/forward compatibility for migrations and API changes, feature-flag or staged-rollout need for risky changes.
   - **Maintainability** — naming, duplicated logic, comment quality (comments should carry non-obvious *why*, not restate *what*) — but only after the above; this is the least important pass.
4. **Rank and write findings**, most severe first:
   - **Blocker** — will break in production or is actively unsafe; must fix before merge.
   - **Should-fix** — real risk or real cost, but not merge-blocking on its own; strong recommendation.
   - **Consider** — genuine improvement, author's call.
   - **Question** — not enough context to judge; ask rather than assume.

   Each finding needs: file:line, what's wrong, the concrete failure scenario (specific input/state → bad outcome), and a specific fix — not "this could be cleaner."
5. **Give a verdict.** End with one of **Approve**, **Approve with comments** (should-fix/consider items, no blockers), or **Request changes** (has a blocker) — plus one sentence on the overall risk of the change. Staff-level review commits to a call; it doesn't just list observations and leave the reader to decide.

## Guardrails

- **Never post anything to GitHub.** Don't run `gh pr comment`, `gh pr review`, `gh pr merge`, or any other command that writes to the PR — no exceptions, even if asked to "leave comments" or "approve it." Output the full review as text in the response; the human posts it manually after reading it.
- Don't flag anything a linter or formatter already enforces (whitespace, import order, etc.) — assume tooling owns that.
- Don't invent requirements the change wasn't trying to meet. Review against its actual goal, not an idealized one.
- Don't pad the review by restating what the diff does — assume the reader can read the diff; only write about what's *wrong* or *worth deciding*.
- If the diff is too large or mixes unrelated concerns to review responsibly in one pass, say so explicitly and recommend splitting it, rather than skimming and rubber-stamping.
- Praise is fine when a decision is genuinely sharp (a non-obvious tradeoff handled well) — but keep it rare and specific, not a courtesy sandwich around every finding.
