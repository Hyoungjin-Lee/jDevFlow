"""
security/ — Cross-platform secret management package for jDevFlow.

Usage:
    from security.secret_loader import load_secret
    api_key = load_secret("MY_API_KEY")

Do NOT import keychain_manager or credential_manager directly.
Always use secret_loader, which picks the right backend automatically.
"""
