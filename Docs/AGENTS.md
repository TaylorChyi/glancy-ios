# AGENTS.md – Agent Automation Guide (Glancy‑iOS)

> **Purpose**  This file tells ChatGPT Codex \*\*how to act on \*\****glancy‑ios***: build, test, respect code style and stay within allowed directories.
>
> *The ******************business‑level requirement specification****************** lives in ****************`README.md`**************** (English, 中文, 日本語).  Whenever README changes, update the Traceability Matrix & Acceptance Criteria there so Codex can regenerate tests in sync.*

```yaml
root: true            # Instruct Codex to apply the rules repo‑wide
version: 0.1.0        # Semantic version of this specification
updated: 2025‑06‑05    # ISO‑8601; keep in sync with CHANGELOG
```

---


## 1  Commands for Codex

```bash
# Build everything (no network)
make build
# Fast feedback unit tests
pytest -q
# Contract & BDD tests
npm run test:contract && npm run test:bdd
# Performance smoke
make perf
```

Any patch **must** leave all of the above commands with exit 0.

---

## 2  Restricted Areas (Glancy‑iOS Specific)

The paths below are **off‑limits** for automated edits. Codex may propose changes in a PR but must not commit directly.

| Path                               | Why protect it?                                                                       |
| ---------------------------------- | ------------------------------------------------------------------------------------- |
| `fastlane/**`                      | CI/CD scripts used for TestFlight & App Store delivery. Mis‑edits could break deploy. |
| `Pods/**` & `Podfile.lock`         | Third‑party dependencies are managed via CocoaPods; lockfile dictates exact versions. |
| `Glancy.xcodeproj/project.pbxproj` | Xcode project file is prone to merge conflicts; manual review only.                   |
| `Scripts/ci/**`                    | Shared build pipelines; coordinated with server config.                               |
| `Resources/Assets.xcassets`        | Design‑approved assets; changes require designer sign‑off.                            |
| `docs/architecture/**`             | High‑level diagrams—update only after architecture review.                            |

If a change is essential, Codex should open a **draft PR**, tag `@TaylorChyi` and `@ios‑maintainers`, and wait for approval.

---

## 3  Release & Milestone Log

We adopt **Semantic Versioning 2.0.0** (MAJOR.MINOR.PATCH) ([semver.org](https://semver.org/?utm_source=chatgpt.com)):

* **MAJOR** = breaking API or architectural changes.
* **MINOR** = backward‑compatible features, completed epics or stories.
* **PATCH** = backward‑compatible bug‑fixes or CI only.

### Milestone cadence

Instead of updating this log on every commit, we create an entry **per GitHub Milestone** (e.g., *Story: In‑App Purchase 1.0*). A milestone closes when:

1. All linked issues/PRs are merged.
2. Unit and UI tests pass on CI.
3. Acceptance criteria in `README.md` are met.

**Template**

```markdown
### [1.2.0] – 2025‑07‑14 (Milestone: IAP MVP)
Added: • FR‑010 In‑App Purchase • UI paywall screen
Fixed: • Crash on SettingsView
```

A running log is stored in `CHANGELOG.md` and updated at the **Merge PR** that bumps the version.

---

  Change Log (spec only)

| Version | Date       | Author           | Summary                                     |
| ------- | ---------- | ---------------- | ------------------------------------------- |
| 0.1.0   | 2025‑06‑05 | @author‑initials | Initial draft imported from project charter |

Append a row for every spec update; bump `version:` in the YAML header accordingly.

---

## 4  Maintenance Workflow

1. **Edit requirements in README** ➜ update Traceability Matrix there.
2. Trigger a **Codex *********************************Code********************************* task** titled *“Sync tests with spec vX.Y.Z”*.
3. Review the generated diff & new/updated tests.
4. Merge after CI passes.
5. Repeat.

> This feedback loop guarantees that code & tests always reflect the latest business truth.

---

## 5  Requirements Status Tracking

To make progress visible and auditable, each requirement row gains a **Status** column with one of:

* `Planned` – defined but no implementation yet
* `In‑Progress` – branch/PR open
* `Implemented` – merged but tests red
* `Verified` – tests green & acceptance criteria met

Update status in the README FR/NFR tables and the Traceability Matrix there when moving through stages. Codex must refuse to mark “Verified” unless all mapped tests pass.

---

## 6  Pull Request Submission Structure

When opening a PR (whether human‑authored or Codex‑generated) you **must use** the template below. Codex should auto‑populate each field; humans must not remove any section.

| Field                      | Required      | Details                                                                                                                        |
| -------------------------- | ------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| **Title**                  | Yes           | Prefix with `[Feat]`, `[Fix]`, `[Chore]`, `[Docs]`, etc., followed by a concise summary (e.g., `[Feat] Add Dark‑Mode toggle`). |
| **Issue / Milestone Link** | Yes           | `Closes #123` and/or milestone name (`Sprint 2025‑07`).                                                                        |
| **Change Type**            | Yes           | One of `Breaking`, `Feature`, `Bug‑fix`, `Refactor`, `Docs`, `CI`.                                                             |
| **Description**            | Yes           | 1‑2 paragraphs answering *Why* and *What*, referencing FR/NFR IDs.                                                             |
| **Checklist**              | Yes           | - \[ ] Updated README/NFR/FR- \[ ] Updated spec (this file) if any DQ‑rule touched- \[ ] Added/updated unit & UI tests         |
| **Screenshots / GIF**      | If UI changed | Embed or attach for visual review.                                                                                             |
| **Smoke Test Log**         | Auto          | Codex pastes summary of `pytest -q`, `xcodebuild test`, `npm run lint`.                                                        |
| **Status Transition**      | Auto          | Update Status column in §8 for each affected requirement.                                                                      |

> **Blocking rules**: Codex will convert the PR to **Draft** and request changes if any checklist item is unchecked, CI fails, or Status columns are missing.

---

## 7 Documentation Quality & Style Requirements

To ensure every future **specification change is crystal‑clear and rich enough for automatic test generation**, follow the rules below. These rules are *binding* for any Codex‑generated content and for human contributors alike.

| Rule ID | Scope               | Requirement                                                                                                                      | Rationale                                                                           |
| ------- | ------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| DQ‑01   | Functional Req      | Each **FR** section **must** include: **Context**, **Main Flow**, **Alternative Flows**, **Post‑conditions**, **Exceptions**.    | Mirrors IEEE 29148 recommended requirement attributes, preventing ambiguous intent. |
| DQ‑02   | Acceptance Criteria | ≥ 3 scenarios per FR: **happy path**, **boundary**, **negative**. Use Given/When/Then and reference domain terms from `README` glossary.        | Multiple scenarios improve test coverage and follow Gherkin best practices.         |
| DQ‑03   | Traceability        | Update the Traceability Matrix in README simultaneously with the spec edit. If a row is missing a test file path, Codex must scaffold one. | Ensures ISO 29119 traceability and living documentation alignment.                  |
| DQ‑04   | Rationale           | Every FR / NFR table row must have a one‑sentence **Why** after the Description.                                                 | Makes intent explicit for future maintainers.                                       |
| DQ‑05   | Diagrams            | If a flow involves > 2 actors or async messaging, include a **PlantUML sequence diagram** under the FR.                          | Visual flow clarifies time‑ordered interactions.                                    |
| DQ‑06   | Metrics             | For each NFR, specify the **measurement method** and **dashboard/location**.                                                     | Enables automated performance/security smoke tests.                                 |
| DQ‑07   | Length              | For a major version bump (X.*.*), the diff to this file should exceed **150 lines** or 1 500 words, whichever is smaller.        | Guards against superficial, under‑specified changes.                                |
| DQ‑08   | Language            | Use active voice; avoid vague verbs like “support”; limit sentences to ≤ 25 words.                                               | Improves machine parsing and human clarity.                                         |
| DQ‑09   | Examples            | Provide at least **one concrete data example** (payload, SQL, etc.) for new APIs or data models.                                 | Demonstrates edge cases and expected formatting.                                    |

> **Codex enforcement**  If a Pull Request changes code without updating the relevant DQ‑rules in this spec, Codex should request changes and link to the missing rule IDs.

---

## 8  Build & Test Commands

These commands are executed sequentially by Codex in a **network‑isolated** container.  Any non‑zero exit status aborts the PR and sends the logs back as a Draft.

```yaml
run:
  # 1️⃣ Clean build for the main scheme on the default iOS 18 simulator
  - xcodebuild \
      -scheme Glancy \
      -configuration Debug \
      -destination 'platform=iOS Simulator,name=iPhone 15,OS=18.0' \
      clean build
  # 2️⃣ Unit tests with HTML & JUnit summary
  - fastlane scan scheme:Glancy output_directory:Reports
  # 3️⃣ Snapshot & UI tests (multi‑locale)
  - fastlane snapshot devices:"iPhone 15" languages:"en-US,zh-Hans,ja-JP"
  # 4️⃣ Lint & auto‑format
  - swiftlint --strict
  - swiftformat .
fail-on-error: true
```

> Codex must embed `Reports/junit.xml` summary and lint violations in the PR body.

---

## 9  Code‑Style Guidelines

| Tool                     | Command              | Config file                   | Blocker level                           |
| ------------------------ | -------------------- | ----------------------------- | --------------------------------------- |
| **SwiftLint**            | `swiftlint --strict` | `.swiftlint.yml` (repo root)  | Error on any violation                  |
| **SwiftFormat**          | `swiftformat .`      | `.swiftformat` (root)         | Auto‑fix + error if unformatted remains |
| **Conventional Commits** | commit-msg hook      | `Scripts/ci/commit_lint.sh`   | Reject non‑conforming messages          |
| **File Header Template** | pre‑commit hook      | `Scripts/ci/insert_header.sh` | Added to new files                      |

Codex must run SwiftFormat before committing generated files.  PRs failing SwiftLint are converted to **Draft**.

---

## 10  Release Automation (Fastlane)

| Lane       | Purpose                                                               | Triggers                           |
| ---------- | --------------------------------------------------------------------- | ---------------------------------- |
| `beta`     | Sign, upload to TestFlight, post‑upload Slack message                 | Merging to `develop` branch        |
| `appstore` | Increment build, run screenshots, notarise, push to App Store Connect | Tag `vMAJOR.MINOR.PATCH` on `main` |

Codex may **propose** a release by pushing a tag & opening a “Release Candidate” PR, but cannot run `appstore` lane without manual approval.

---

## 11  Security, Privacy & Secrets

* **Secrets injection**: API keys, Firebase plist, signing certificates are mounted via the Codex Secrets pane. Hard‑coded tokens are banned.
* **Network policy**: Only `https://api.glancy.app` and Apple endpoints allowed. Codex must refuse new hard‑coded domains.
* **GDPR / PDPA**: Any new PII field requires a `dataImpact` comment in the PR description.

---

## 12  Accessibility & Localisation

* All new screens must pass `accessibilityAudit()` UITest.
* Snapshot lane must include RTL check for Arabic.
* Localisable strings **must** provide `en`, `zh‑Hans`, `ja` keys; Codex auto‑fails PR if missing.

---

## 13  Performance & Crash Metrics

| ID      | Metric              | Target               | Source            |
| ------- | ------------------- | -------------------- | ----------------- |
| NFR-P02 | Cold‑launch P95     | ≤ 1.5 s              | Firebase Perf SDK |
| NFR-R02 | Crash‑free sessions | ≥ 99.5 % rolling 7 d | Crashlytics       |

Codex fetches latest metrics via Firebase REST; if regression > 5 %, mark PR as **Blocked**.
