# Releasing

Use this checklist for pub.dev releases.

1. Confirm the next version in `pubspec.yaml` follows semantic versioning.
2. Update `CHANGELOG.md` and `RELEASE_NOTES.md`.
3. Update README snippets if the published version or user-facing API changed.
4. Run:

```bash
dart format --output=none --set-exit-if-changed lib test example/lib
dart analyze
flutter test
flutter pub publish --dry-run
```

5. Commit the release changes.
6. Tag the commit as `v<version>`, for example `v5.1.1`.
7. Push the branch and tag.
8. Verify the publish workflow completes and the pub.dev page shows the new version.
