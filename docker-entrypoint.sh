#!/bin/bash
set -e

# Only create .Renviron if variables exist and file doesn't exist
if [[ ! -f "$HOME/.Renviron" ]] && \
   [[ -n "$SYNAPSE_USERNAME" ]] && \
   [[ -n "$SYNAPSE_APIKEY" ]]; then
  cat > "$HOME/.Renviron" <<EOF
SYNAPSE_USERNAME=$SYNAPSE_USERNAME
SYNAPSE_APIKEY=$SYNAPSE_APIKEY
EOF
  chmod 600 "$HOME/.Renviron"
fi

exec "$@"
