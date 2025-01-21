# Like GNU `make`, but `just` rustier.
# https://just.systems/
# run `just` from this directory to see available commands

has_backup := path_exists("/etc/nix/nix.conf.before-nix-darwin")
has_nix := path_exists("/etc/nix/nix.conf")

alias fmt := format

# Default command when 'just' is run without arguments
default:
  @just run

# Update nix flake
[group('Main')]
update:
  nix flake update

# Performs automated code analysis to identify potential programming errors, stylistic issues, and suspicious constructs. It helps maintain consistent code quality and prevents common programming mistakes.
[group('Development')]
lint:
  statix check
  deadnix

[group('Development')]
check:
  nix flake check

[group('Development')]
format:
  nix fmt

# Denvironment
[group('dev')]
shell:
  nix develop

# Activate the configuration
[group('main')]
run:
    nh home switch .

# Install nix-darwin for lix and nix without determine package
[group('Installation')]
install:
  nix --extra-experimental-features "nix-command flakes" run .#activate 

# ...
migrate_nix_configuration:
  sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin

# ---- Secrets Management with SOPS ----

# Initialize SOPS configuration and create necessary directories
[group('secrets')]
secrets-init:
    mkdir -p secrets
    test -f .sops.yaml || echo "Please configure .sops.yaml with your GPG key"

# Edit or create a new secret file (usage: just secrets-edit path/to/secret.yaml)
[group('secrets')]
secrets-edit file:
    sops {{file}}

# Show all secret files tracked by SOPS
[group('secrets')]
secrets-ls:
    find secrets -type f -name "*.yaml" -o -name "*.json" -o -name "*.env"

# Rotate all secrets (re-encrypt with new keys)
[group('secrets')]
secrets-rotate:
    find secrets -type f -name "*.yaml" -o -name "*.json" -o -name "*.env" | xargs -I {} sops updatekeys {}

# Create a new secret file from a template
[group('secrets')]
secrets-new name:
    #!/usr/bin/env bash
    set -euo pipefail
    FILE="secrets/{{name}}.yaml"
    if [ -f "$FILE" ]; then
        echo "Error: $FILE already exists"
        exit 1
    fi
    echo "# SOPS encrypted secrets for {{name}}" > "$FILE"
    echo "# Add your secrets below in plain text, they will be encrypted on save" >> "$FILE"
    sops "$FILE"

# Show the difference between two versions of a secret file
[group('secrets')]
secrets-diff file ref="HEAD^":
    git show {{ref}}:{{file}} | sops -d /dev/stdin > /tmp/old
    sops -d {{file}} > /tmp/new
    diff -u /tmp/old /tmp/new || true
    rm /tmp/old /tmp/new

# Verify all secret files are properly encrypted
[group('secrets')]
secrets-verify:
    #!/usr/bin/env bash
    set -euo pipefail
    find secrets -type f \( -name "*.yaml" -o -name "*.json" -o -name "*.env" \) -print0 | \
    while IFS= read -r -d '' file; do
        echo "Verifying $file..."
        if grep -l "^[^#].*: ENC\[.*\]" "$file" > /dev/null; then
            echo "✓ $file is properly encrypted"
        else
            echo "✗ $file may contain unencrypted secrets!"
            exit 1
        fi
    done

# Generate a new Age key pair
[group('secrets')]
secrets-gen-age:
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p ~/.config/sops/age
    if [ ! -f ~/.config/sops/age/keys.txt ]; then
        age-keygen -o ~/.config/sops/age/keys.txt
        echo "Age key pair generated at ~/.config/sops/age/keys.txt"
        echo "Public key:"
        age-keygen -y ~/.config/sops/age/keys.txt
    else
        echo "Age key pair already exists at ~/.config/sops/age/keys.txt"
        echo "Public key:"
        age-keygen -y ~/.config/sops/age/keys.txt
    fi

# Show help for secrets management commands
[group('secrets')]
secrets-help:
    @echo "Available secrets management commands:"
    @echo
    @echo "just secrets-init              - Initialize SOPS configuration"
    @echo "just secrets-edit FILE         - Edit or create a secret file"
    @echo "just secrets-ls                - List all secret files"
    @echo "just secrets-rotate            - Rotate all secrets"
    @echo "just secrets-new NAME          - Create a new secret file"
    @echo "just secrets-diff FILE [REF]   - Show diff between versions"
    @echo "just secrets-verify            - Verify all secrets are encrypted"
    @echo "just secrets-gen-age          - Generate a new Age key pair"
    @echo
    @echo "Examples:"
    @echo "  just secrets-new github     # Creates secrets/github.yaml"
    @echo "  just secrets-edit secrets/github.yaml"
    @echo "  just secrets-diff secrets/github.yaml HEAD^"
