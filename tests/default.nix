inputs:
# Use meld to combine multiple subflakes
# Each subflake is a separate file that takes inputs and returns outputs
inputs.flake-utils.lib.meld inputs [
  ./latexmk-checks.nix

  # Add more template checks here in the future
  # ./ruby-checks.nix
  # ./r-checks.nix
]
