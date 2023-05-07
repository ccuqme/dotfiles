#!/bin/bash
set -euo pipefail

check_updates() {
    upgrade_check_output=$(rpm-ostree upgrade --check 2>&1)
    available_updates=$(echo "$upgrade_check_output" | grep 'AvailableUpdate:' || true)
    if [ -n "$available_updates" ]; then
        num_updates=$(echo "$upgrade_check_output" | grep -oP '(?<=Diff: )[0-9]+')
        version=$(echo "$upgrade_check_output" | grep -oP '(?<=Version: )[^\s]+')
        commit=$(echo "$upgrade_check_output" | grep -oP '(?<=Commit: )[^\s]+')
        gpg_signature=$(echo "$upgrade_check_output" | grep -oP '(?<=GPGSignature: )[^\n]+')

        update_icon="🔄"
        echo "$update_icon $num_updates"
        echo "Version: $version | Commit: $commit | GPGSignature: $gpg_signature | Diff: $num_updates upgraded"
        return 0
    else
        echo "No updates available"
        return 1
    fi
}

check_updates
