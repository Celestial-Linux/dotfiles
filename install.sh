#!/bin/sh

# -e: exit on error
# -u: exit on unset variables
set -eu

if ! chezmoi="$(command -v chezmoi)"; then
  bin_dir="${HOME}/.local/bin"
  chezmoi="${bin_dir}/chezmoi"
  echo "Installing chezmoi to '${chezmoi}'" >&2
  if command -v curl >/dev/null; then
    chezmoi_install_script="$(curl -fsSL https://chezmoi.io/get)"
  elif command -v wget >/dev/null; then
    chezmoi_install_script="$(wget -qO- https://chezmoi.io/get)"
  else
    echo "To install chezmoi, you must have curl or wget installed." >&2
    exit 1
  fi
  sh -c "${chezmoi_install_script}" -- -b "${bin_dir}"
  unset chezmoi_install_script bin_dir
fi

# POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"

install_pre_commit_hook() {
  if [ "${CHEZMOI_INSTALL_PRE_COMMIT:-1}" = "0" ]; then
    echo "Skipping pre-commit hook setup because CHEZMOI_INSTALL_PRE_COMMIT=0." >&2
    return
  fi

  if ! command -v pre-commit >/dev/null 2>&1; then
    echo "Skipping pre-commit hook setup because pre-commit is not installed." >&2
    return
  fi

  if ! command -v git >/dev/null 2>&1 || ! git -C "${script_dir}" rev-parse --git-dir >/dev/null 2>&1; then
    echo "Skipping pre-commit hook setup because '${script_dir}' is not a Git repository." >&2
    return
  fi

  echo "Installing pre-commit hooks in '${script_dir}'" >&2
  if ! (
    cd "${script_dir}"
    pre-commit install
  ); then
    echo "Warning: failed to install pre-commit hooks in '${script_dir}'." >&2
  fi
}

install_pre_commit_hook

set -- init --apply --source="${script_dir}"

echo "Running 'chezmoi $*'" >&2
# exec: replace current process with chezmoi
exec "$chezmoi" "$@"