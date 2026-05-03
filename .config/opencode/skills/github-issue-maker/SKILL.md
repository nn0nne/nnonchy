---
name : github-issue-maker
description : A github issue maker is a skills to make a github issue for the projects in github. Use this skill to create a github issue for the project in github. You can specify the title, body, labels, and assignees for the issue.
author : Romario Marcal
---


## Issue Structure 

**Title:** <type>(<scope>): <short imperative summary>   ← one line, ≤72 chars

**Type:** Bug | Feature | Refactor | Chore | Docs

**Description**
One paragraph. What is the problem or goal? Why does it matter?

**Acceptance Criteria**
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3 (add as many as needed, minimum 2)

**Steps to Reproduce** *(Bug only — omit for non-bugs)*
1. Step one
2. Step two
3. Observed vs. expected result

**Proposed Solution / Notes** *(optional — include only if genuinely useful)*
Brief approach or technical notes. Skip if unknown.

**Labels:** <comma-separated labels>
**Assignees:** <@handle or "unassigned">
**Milestone:** <name or "none">


## Title Prefixes

- **Bug fix:** `fix:`
- **New feature:** `feat:`
- **Refactor:** `refactor:`
- **Chore:** `chore:`
- **Documentation:** `docs:`


## Labels References 

Use the minimal set that applies:

**Type**: bug · feature · refactor · chore · docs
**Priority**: priority: high · priority: medium · priority: low
**Status**: needs-triage · in-progress · blocked
**Size**: size: S · size: M · size: L
