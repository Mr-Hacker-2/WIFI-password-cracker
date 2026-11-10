#!/usr/bin/env bash

set -euo pipefail

outfile="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/WiFi_Networks.txt"

{
    printf 'Saved Wi-Fi Network Names\n'
    printf 'Generated: %s\n' "$(date)"
    printf '%s\n\n' '====================================='

    if ! command -v nmcli >/dev/null 2>&1; then
        printf 'NetworkManager (nmcli) is not available in this environment.\n'
        printf 'ChromeOS does not expose its saved Wi-Fi profiles to Chromebook Linux apps.\n'
    else
        profiles="$(nmcli -t -f NAME,TYPE connection show | awk -F: '$2 == "802-11-wireless" { sub(/\\:/, ":", $1); print $1 }')"
        if [[ -z "$profiles" ]]; then
            printf 'No saved Wi-Fi profiles are visible to this environment.\n'
            printf 'On Chromebook, ChromeOS Wi-Fi profiles are not exposed to Linux apps.\n'
        else
            printf '%s\n' "$profiles" | while IFS= read -r profile; do
                printf 'Network: %s\n' "$profile"
            done
        fi
    fi

    printf '\nThis report lists network names only; it does not display passwords.\n'
} > "$outfile"

printf 'Done. Results saved to:\n%s\n' "$outfile"