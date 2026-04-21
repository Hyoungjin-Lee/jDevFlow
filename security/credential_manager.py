"""
credential_manager.py — Windows Credential Manager backend

Stores and retrieves secrets using the Windows Credential Manager
via the `keyring` library (pip install keyring).

Do NOT import this module directly — use secret_loader.py instead.

Installation:
    pip install keyring
"""

import sys

SERVICE_NAME = "joneflow"

try:
    import keyring
    _KEYRING_AVAILABLE = True
except ImportError:
    _KEYRING_AVAILABLE = False


def _check_keyring():
    if not _KEYRING_AVAILABLE:
        raise ImportError(
            "The 'keyring' library is required on Windows.\n"
            "Install it with: pip install keyring"
        )


def get_secret(key: str) -> str:
    """Retrieve a secret from Windows Credential Manager."""
    _check_keyring()
    value = keyring.get_password(SERVICE_NAME, key)
    if value is None:
        raise KeyError(
            f"Secret '{key}' not found in Credential Manager (service: {SERVICE_NAME}). "
            "Run: python security/secret_loader.py --setup"
        )
    return value


def set_secret(key: str, value: str) -> None:
    """Save or update a secret in Windows Credential Manager."""
    _check_keyring()
    keyring.set_password(SERVICE_NAME, key, value)


def delete_secret(key: str) -> None:
    """Delete a secret from Windows Credential Manager."""
    _check_keyring()
    try:
        keyring.delete_password(SERVICE_NAME, key)
    except keyring.errors.PasswordDeleteError:
        print(f"[credential_manager] '{key}' not found or already deleted.")


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="Windows Credential Manager")
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
        print(f"✅ '{args.set[0]}' saved to Credential Manager.")
    elif args.delete:
        delete_secret(args.delete)
        print(f"🗑  '{args.delete}' deleted from Credential Manager.")
    else:
        parser.print_help()
