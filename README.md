<p align="center">
  <img src="Docs/icon.jpg" alt="Glancy App Icon" width="150" style="border-radius: 20px;"/>
</p>

- [English Version](README.md)
- [中文版](Docs/README_zh.md)
- [日本語版](Docs/README_ja.md)

# Glancy

Glancy is a premium multilingual dictionary app designed to provide users with quick and accurate translations and usage examples. With its intuitive interface and advanced language processing, Glancy helps language learners, professionals, and everyday users to explore words and phrases seamlessly across multiple languages.

## Overview

Glancy offers:
- **Multilingual Translations:** Get accurate translations and usage examples in up to three selected languages.
- **Advanced Search:** Use the bottom search bar with an integrated send button for quick word lookups.
- **Personalized Language Settings:** Choose your preferred languages from a curated list. These selections control which language buttons appear on the main screen and determine the translations displayed.
- **Cloud-Powered Experience:** Sync your search history, favorites, and settings securely across devices.
- **User Management:** Enjoy seamless sign-up, login, and profile management with options for both anonymous and full account usage.

## How It Works

1. **Smart Query:**
   When you search for a word, Glancy first checks its cloud database for a cached definition. If found, the result is displayed instantly; otherwise, our advanced language engine is used to fetch the translation and usage examples.
2. **Intuitive Interface:**
   The main screen features toggleable language buttons, a clear results area, and a bottom-aligned search bar with an embedded send button.
3. **Personalized Experience:**
   Customize your language preferences in the settings page. Your selected languages appear on the main screen and directly affect the translations retrieved.

## Get Started

Download Glancy from the App Store and transform your language learning experience.
For business inquiries, please contact: [support@glancy.com](mailto:support@glancy.com).

## Functional Requirements

### FR-001 Word Lookup
**Context**  The user wants to see translations and examples for a single term.
**Main Flow**
1. The user enters a word in the search bar.
2. The app checks the LeanCloud cache.
3. If cached, the result is returned immediately; otherwise, the app queries DeepSeek.
4. The response is stored in LeanCloud and shown on screen.
**Alternative Flows**  If the network call fails, an error message appears and no history entry is saved.
**Post-conditions**  The word and timestamp are stored in search history.
**Exceptions**  Empty input prompts the user for valid text.
#### Test Cases
- Cache hit returns result for "hello" instantly.
- Cache miss triggers DeepSeek call then saves result.
- Network failure shows error and skips history entry.

### FR-002 Manage Preferred Languages
**Context**  A user customizes which languages appear in search results.
**Main Flow**
1. The user opens language settings.
2. The user toggles one or more languages (maximum three).
3. Upon saving, the preference is persisted locally.
**Alternative Flows**  Selecting more than three languages shows no effect.
**Post-conditions**  The language bar updates immediately.
**Exceptions**  At least one language must remain selected.
#### Test Cases
- Select two languages and confirm they persist after restart.
- Attempt to choose four languages; verify only three remain active.
- Deselect all but one language; ensure at least one is enforced.

### FR-003 Authentication
**Context**  Users can log in or out to sync data.
**Main Flow**
1. A user chooses a login method: password or verification code.
2. LeanCloud verifies the credentials and returns a user object.
3. On success, the profile view shows account details.
**Alternative Flows**  Invalid credentials display an error and keep the user logged out.
**Post-conditions**  When logged in, search history and settings sync to the cloud.
**Exceptions**  Network errors show a retry prompt.
#### Test Cases
- Login with valid password; profile shows user info.
- Login with invalid code; error message appears.
- Offline login attempt prompts retry.

### FR-004 Search History Management
**Context**  Users revisit recent queries.
**Main Flow**
1. Each successful search is saved as a `SearchRecord`.
2. The history view lists up to ten recent words.
3. Tapping an entry repeats the lookup. Long press removes it.
**Alternative Flows**  None.
**Post-conditions**  History older than ten entries is automatically deleted.
**Exceptions**  Persistence failures are ignored.
#### Test Cases
- Perform search, then verify word saved in history list.
- Add 11 entries; first entry is automatically removed.
- Long press an entry; confirm it is deleted.

## Non-Functional Requirements

| ID | Category | Requirement | Metric / Threshold |
|----|----------|-------------|--------------------|
| NFR-S01 | Security | All API calls use HTTPS and store keys in plist files. | Static scan passes with zero hard-coded secrets |
| NFR-P01 | Performance | Cached word lookup responds within 500&nbsp;ms. | Unit test `GlancyTests.swift::test_performance` |
| NFR-R01 | Reliability | LeanCloud operations succeed 99.5&nbsp;% monthly. | Sentry dashboard `glancy.reliability` |
### NFR Test Cases
- NFR-S01: Run static scan to ensure no hard-coded secrets.
- NFR-P01: Measure cached lookup; must finish within 500 ms.
- NFR-R01: Monitor Sentry to verify 99.5% operation success.

## Traceability Matrix

| Requirement | Unit Test(s) | Integration | E2E / BDD |
|-------------|--------------|-------------|-----------|
| FR-001 | `GlancyTests/GlancyTests.swift::test_search_word` | – | – |
| FR-002 | `GlancyTests/GlancyTests.swift::test_language_preference` | – | – |
| FR-003 | `GlancyTests/GlancyTests.swift::test_authentication` | – | – |
| FR-004 | `GlancyTests/GlancyTests.swift::test_history` | – | – |
| NFR-P01 | `GlancyTests/GlancyTests.swift::test_performance` | N/A | `Reports/junit.xml` |

## Requirements Authoring Guide

### Functional Requirements

Use the following structure for each FR:

* **Context** – short paragraph describing the situation
* **Main Flow** – numbered steps detailing the normal path
* **Alternative Flows** – how deviations are handled
* **Post-conditions** – resulting state when successful
* **Exceptions** – error cases and recovery actions

List acceptance criteria below the FR in Gherkin `Given/When/Then` form, covering happy path, boundary, and negative scenarios.

### Non-Functional Requirements

Record NFRs in a table with columns: ID, Category, Requirement, Metric / Threshold. Follow each row with one sentence explaining *why* the requirement exists.

### Traceability Matrix

Keep a matrix mapping every requirement ID to its unit, integration, and end-to-end tests. Every row must reference at least one test. Update the matrix whenever tests change.

### Test Case Description Guidelines
- Use bullet points or tables for clarity.
- Each requirement lists happy, boundary, and negative cases.
- Prefix each case with the requirement ID.
- Write in active voice under 25 words.
- Align with acceptance criteria and traceability matrix.
