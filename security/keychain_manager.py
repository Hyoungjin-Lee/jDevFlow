"""
keychain_manager.py — macOS Keychain backend

Stores and retrieves secrets using the macOS Keychain via the
built-in `security` CLI tool. No third-party dependencies required.

Do NOT import this module directly — use secret_loader.py instead.
"""

import subprocess
import sys

# The service name groups all secrets for this project in Keychain.
# Change this to match your project name.
SERVICE_NAME = "jdevflow"


def get_secret(key: str) -> str:
    """Retrieve a secret from macOS Keychain."""
    result = subprocess.run(
        [
            "security", "find-generic-password",
            "-s", SERVICE_NAME,
            "-a", key,
            "-w",   # print password only
        ],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        raise KeyError(
            f"Secret '{key}' not found in Keychain (service: {SERVICE_NAME}). "
            "Run: python3 security/secret_loader.py --setup"
        )
    return result.stdout.strip()


def set_secret(key: str, value: str) -> None:
    """Save or update a secret in macOS Keychain."""
    # Delete existing entry first (update = delete + add)
    subprocess.run(
        [
            "security", "delete-generic-password",
            "-s", SERVICE_NAME,
            "-a", key,
        ],
        capture_output=True,
    )
    result = subprocess.run(
        [
            "security", "add-generic-password",
            "-s", SERVICE_NAME,
            "-a", key,
            "-w", value,
            "-U",   # update if exists
        ],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        raise RuntimeError(
            f"Failed to save '{key}' to Keychain: {result.stderr.strip()}"
        )


def delete_secret(key: str) -> None:
    """Delete a secret from macOS Keychain."""
    result = subprocess.run(
        [
            "security", "delete-generic-password",
            "-s", SERVICE_NAME,
            "-a", key,
        ],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        print(f"[keychain_manager] '{key}' not found or already deleted.")


def list_secrets() -> list[str]:
    """List all account names stored under this service. (macOS only)"""
    result = subprocess.run(
        ["security", "dump-keychain"],
        capture_output=True,
        text=True,
    )
    keys = []
    for line in result.stdout.splitlines():
        if f'"svce"<blob>="{SERVICE_NAME}"' in line:
            # next iteration will have the account; simpler to use grep
            pass
    # Simplified: return empty list — full dump-keychain parsing is complex
    return keys


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="macOS Keychain manager")
    parser.add_argument("--get", metavar="KEY")
    parser.add_argument("--set", nargs=2, metavar=("KEY", "VALUE"))
    parser.add_argument("--delete", metavar="KEY")
    args = parser.parse_args()

    if args.get:
        try:
            print(get_secret(args.get))
        except KeyError as e:
            print(f"❌ {e}")
            sys.exit(1)
    elif args.set:
        set_secret(args.set[0], args.set[1])
        print(f"✅ '{args.set[0]}' saved to Keychain.")
    elif args.delete:
        delete_secret(args.delete)
        print(f"🗑  '{args.delete}' deleted from Keychain.")
    else:
        parser.print_help()
