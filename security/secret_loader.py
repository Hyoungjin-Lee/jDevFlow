"""
secret_loader.py — Cross-platform secret loading

Detects the current OS and routes to the appropriate backend:
  - macOS  → keychain_manager.py  (macOS Keychain)
  - Windows → credential_manager.py (Windows Credential Manager)
  - Linux  → environment variables (.env file fallback)

Usage:
    from security.secret_loader import load_secret, save_secret

    api_key = load_secret("MY_API_KEY")
    save_secret("MY_API_KEY", "abc123")

First-time setup:
    python3 security/secret_loader.py --setup
"""

import os
import platform
import sys
import argparse

PLATFORM = platform.system()  # "Darwin", "Windows", "Linux"


# ---------------------------------------------------------------------------
# Public API
# ---------------------------------------------------------------------------

def load_secret(key: str) -> str:
    """
    Load a secret by key from the OS secure store.
    Raises KeyError if the secret is not found.
    """
    if PLATFORM == "Darwin":
        from security.keychain_manager import get_secret
        return get_secret(key)
    elif PLATFORM == "Windows":
        from security.credential_manager import get_secret
        return get_secret(key)
    else:
        # Linux / CI fallback: read from environment variable
        value = os.environ.get(key)
        if value is None:
            raise KeyError(
                f"Secret '{key}' not found. "
                "On Linux, set it as an environment variable or in a .env file."
            )
        return value


def save_secret(key: str, value: str) -> None:
    """
    Save a secret to the OS secure store.
    """
    if PLATFORM == "Darwin":
        from security.keychain_manager import set_secret
        set_secret(key, value)
    elif PLATFORM == "Windows":
        from security.credential_manager import set_secret
        set_secret(key, value)
    else:
        print(
            f"[secret_loader] Linux detected. "
            f"Please set '{key}' as an environment variable manually."
        )


def delete_secret(key: str) -> None:
    """
    Delete a secret from the OS secure store.
    """
    if PLATFORM == "Darwin":
        from security.keychain_manager import delete_secret as _delete
        _delete(key)
    elif PLATFORM == "Windows":
        from security.credential_manager import delete_secret as _delete
        _delete(key)
    else:
        print(f"[secret_loader] Linux: manually unset the environment variable '{key}'.")


def inject_to_env(*keys: str) -> None:
    """
    Load multiple secrets and inject them into os.environ.
    Useful for libraries that read from environment variables.

    Example:
        inject_to_env("OPENAI_API_KEY", "DATABASE_URL")
    """
    for key in keys:
        try:
            os.environ[key] = load_secret(key)
        except KeyError:
            print(f"[secret_loader] Warning: secret '{key}' not found, skipping.")


# ---------------------------------------------------------------------------
# Interactive setup wizard
# ---------------------------------------------------------------------------

def _setup_wizard():
    print("=" * 60)
    print("  Secret Setup Wizard")
    print(f"  Platform detected: {PLATFORM}")
    print("=" * 60)
    print()
    print("Enter the secrets for this project.")
    print("They will be stored securely in your OS keychain.")
    print("Leave blank to skip a secret.")
    print()

    # Load project-defined secrets from .env.example if available
    secrets_to_set = []
    env_example = os.path.join(os.path.dirname(__file__), "..", ".env.example")
    if os.path.exists(env_example):
        with open(env_example) as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith("#") and "=" in line:
                    key = line.split("=")[0].strip()
                    secrets_to_set.append(key)

    if not secrets_to_set:
        print("No secrets defined in .env.example.")
        print("You can add secrets manually:")
        print("  python3 security/secret_loader.py --set MY_KEY my_value")
        return

    for key in secrets_to_set:
        value = input(f"  {key}: ").strip()
        if value:
            save_secret(key, value)
            print(f"  ✅ '{key}' saved.")
        else:
            print(f"  ⏭  '{key}' skipped.")

    print()
    print("Setup complete. Secrets are stored in your OS keychain.")


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Manage project secrets securely.")
    parser.add_argument("--setup", action="store_true", help="Run the interactive setup wizard")
    parser.add_argument("--set", nargs=2, metavar=("KEY", "VALUE"), help="Save a secret")
    parser.add_argument("--get", metavar="KEY", help="Print a secret value")
    parser.add_argument("--delete", metavar="KEY", help="Delete a secret")
    args = parser.parse_args()

    if args.setup:
        _setup_wizard()
    elif args.set:
        save_secret(args.set[0], args.set[1])
        print(f"✅ '{args.set[0]}' saved.")
    elif args.get:
        try:
            print(load_secret(args.get))
        except KeyError as e:
            print(f"❌ {e}")
            sys.exit(1)
    elif args.delete:
        delete_secret(args.delete)
        print(f"🗑  '{args.delete}' deleted.")
    else:
        parser.print_help()
