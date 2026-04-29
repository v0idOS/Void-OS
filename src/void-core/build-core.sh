echo "Building Core..."
pwsh -NoP -EP Bypass -C "& \"$(dirname "$PWD")/void-tools/local-build.ps1\" -AddLiveLog -ReplaceOldPlaybook -Removals WinverRequirement, Verification -DontOpenPbLocation"