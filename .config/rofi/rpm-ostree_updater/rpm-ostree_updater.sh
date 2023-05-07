#!/usr/bin/env bash

dir="$HOME/.config/rofi/rpm-ostree_updater"
theme="style-1"

set -e

current_commit="$(rpm-ostree status --json | jq -r '.deployments[] | select(.booted) | .checksum')"
upgrade_check_output="$(rpm-ostree upgrade --check 2>&1)"
available_updates=$(echo "$upgrade_check_output" | grep 'AvailableUpdate:' || true)

if [ -n "$available_updates" ]; then
  num_updates=$(echo "$upgrade_check_output" | grep -oP '(?<=Diff: )[0-9]+')
  version=$(echo "$upgrade_check_output" | grep -oP '(?<=Version: )[^\s]+')
  commit=$(echo "$upgrade_check_output" | grep -oP '(?<=Commit: )[^\s]+')
  gpg_signature=$(echo "$upgrade_check_output" | grep -oP '(?<=GPGSignature: )[^\n]+')

  update_options="Update system\nCancel"
  update_message="Updates available: $num_updates\nVersion: $version\nCommit: $commit\nGPGSignature: $gpg_signature\n\n"
  update_message+="Diff output:\n$(rpm-ostree db diff $current_commit $commit)"
  update_message=$(echo -e "$update_message")
else
  update_options="Cancel"
  update_message="No updates available"
fi

selected_option="$(echo -e "$update_options" | rofi -dmenu -i -mesg "$update_message" -p "RPM-OSTree Updates" -theme ${dir}/${theme}.rasi)"

case "$selected_option" in
  "Update system")
    confirmation="$(echo -e "Yes\nNo" | rofi -dmenu -i -mesg "Are you sure you want to update your system?" -p "Confirm Update" -theme ${dir}/${theme}.rasi)"
    if [ "$confirmation" == "Yes" ]; then
      # Display "Updating..." message while the update is in progress
      rofi -e "Updating..." -theme ${dir}/${theme}.rasi &
      rofi_pid=$!
      output=$(rpm-ostree upgrade | grep -v "Run \"systemctl reboot\" to start a reboot")
      # Close the "Updating..." message and display the update result
      kill $rofi_pid
      post_update_action="$(echo -e "Close\nReboot\nShutdown" | rofi -dmenu -i -mesg "$output" -p "Update completed" -theme ${dir}/${theme}.rasi)"

      case "$post_update_action" in
        "Reboot")
          systemctl reboot
          ;;
        "Shutdown")
          systemctl poweroff
          ;;
        "Close"|*)
          ;;
      esac
    fi
    ;;
  "Cancel")
    ;;
esac
