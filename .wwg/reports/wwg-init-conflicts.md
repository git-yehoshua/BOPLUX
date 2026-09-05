# WWG Init Conflict Report

## Summary

WWG init found existing files or target entries and skipped conflicting writes.

## Conflicts

- .wwg - Pre-existing target entry; file-level conflicts will be skipped.
- ReplicatedStorage - Pre-existing target entry; file-level conflicts will be skipped.
- ServerScriptService - Pre-existing target entry; file-level conflicts will be skipped.
- ServerStorage - Pre-existing target entry; file-level conflicts will be skipped.
- StarterCharacterScripts - Pre-existing target entry; file-level conflicts will be skipped.
- StarterPlayerScripts - Pre-existing target entry; file-level conflicts will be skipped.

## Next Steps

- Review conflicts before rerunning init.
- WWG will not overwrite existing files blindly.
