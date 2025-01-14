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
