# TDD Workflow Bootstrap

This repository starts with a Red-Green-Refactor workflow for Phase 1 MVP.

## Subagents

- `.copilot/subagents/tdd-red.prompt.md`
- `.copilot/subagents/tdd-green.prompt.md`
- `.copilot/subagents/tdd-refactor.prompt.md`

Use these prompts when invoking a subagent for each TDD phase.

## First active slice

- Feature: F-1-REV-01 / F-1-REV-04
- Module: `lib/core/services/srs/sm2_srs_service.dart`
- Tests: `test/core/services/srs/sm2_srs_service_test.dart`

## Suggested iteration order

1. Red: Add tests for the next behavior only.
2. Green: Implement the smallest code to pass.
3. Refactor: Remove duplication, keep behavior stable.

## Local setup

Flutter SDK is required but was not found in this environment.

Recommended install path on Windows:
1. Install Puro: `winget install pingbird.Puro`
2. Install Flutter stable: `puro flutter install stable`
3. Set version for this repo: `puro use stable`
4. Verify: `flutter --version`

## Run checks

- `flutter pub get`
- `flutter test`
- `flutter analyze`
