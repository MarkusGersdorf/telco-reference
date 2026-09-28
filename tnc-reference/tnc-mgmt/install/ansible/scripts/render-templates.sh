#!/bin/bash
# Render Ansible templates locally for inspection
# Usage: ./render-templates.sh [template-name]
# Example: ./render-templates.sh agent-config.yaml.j2

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TEMPLATE="${1:-}"
OUTDIR="/tmp/rendered-templates"

mkdir -p "${OUTDIR}"

if [ -n "${TEMPLATE}" ]; then
  ansible -m template \
    -a "src=${SCRIPT_DIR}/templates/${TEMPLATE} dest=${OUTDIR}/${TEMPLATE%.j2}" \
    localhost -e "@${SCRIPT_DIR}/vars.yaml"
  echo "=== ${OUTDIR}/${TEMPLATE%.j2} ==="
  cat "${OUTDIR}/${TEMPLATE%.j2}"
else
  for tmpl in "${SCRIPT_DIR}"/templates/*.j2; do
    name=$(basename "${tmpl}")
    ansible -m template \
      -a "src=${tmpl} dest=${OUTDIR}/${name%.j2}" \
      localhost -e "@${SCRIPT_DIR}/vars.yaml" 2>/dev/null
    echo "=== ${name%.j2} ==="
    cat "${OUTDIR}/${name%.j2}"
    echo ""
  done
fi
