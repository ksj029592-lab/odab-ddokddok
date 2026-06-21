#!/usr/bin/env sh
set -eu

run_flutter() {
  if command -v flutter >/dev/null 2>&1; then
    flutter "$@"
    return
  fi

  if command -v puro >/dev/null 2>&1; then
    puro flutter "$@"
    return
  fi

  echo "Flutter CLI not found. Install Flutter and add it to PATH, or install Puro so azd can run 'puro flutter'." >&2
  exit 1
}

run_flutter pub get
run_flutter build web --release
cp web/staticwebapp.config.json build/web/staticwebapp.config.json

echo "prepackage completed"
