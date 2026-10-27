# Testing and rubric evidence

## Test categories

- Unit: parser and model/database tests in `test/unit/`.
- Widget: navigation smoke test in `test/widget_test.dart`.
- Integration: app-flow smoke test in `test/integration/app_flow_test.dart`.
- Security: Firestore rule contract test in `test/security/firestore_rules_test.dart`.

## Local commands

```powershell
flutter analyze
flutter test --coverage
flutter test test/integration/app_flow_test.dart
```

The CI workflow in `.github/workflows/ci.yml` runs formatting, analysis, tests,
coverage artifact upload, and Android debug build for every push and pull request.

## Evidence still collected manually

Usability testing requires five real participants and should record the task,
completion result, and feedback. Firebase evidence should include a successful
Authentication user and Firestore read/write in the Firebase console.
