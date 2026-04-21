#!/usr/bin/env bash
# setup_security.sh — One-time security setup
#
# Detects OS and runs the appropriate secret setup flow.
# Wraps: python3 security/secret_loader.py --setup
#
# Usage:
#   bash scripts/setup_security.sh

set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "=============================="
echo "  Security Setup"
echo "=============================="
echo ""

OS="$(uname -s)"

case "$OS" in
  Darwin)
    echo "✅ macOS detected — using Keychain"
    ;;
  Linux)
    echo "ℹ️  Linux detected — secrets will use environment variables"
    echo "   Tip: add secrets to your shell profile or use a .env file (not committed)."
    ;;
  MINGW*|MSYS*|CYGWIN*|Windows_NT)
    echo "✅ Windows detected — using Credential Manager"
    # Check keyring is installed
    python3 -c "import keyring" 2>/dev/null || {
      echo "Installing keyring..."
      pip install keyring --quiet
    }
    ;;
  *)
    echo "⚠️  Unknown OS: $OS"
    ;;
esac

echo ""

# Check Python is available
python3 --version &>/dev/null || {
  echo "❌ Python 3 not found. Please install Python 3 first."
  exit 1
}

# Run the setup wizard
python3 "$ROOT/security/secret_loader.py" --setup

echo ""
echo "=============================="
echo "  Security setup complete!"
echo "=============================="
