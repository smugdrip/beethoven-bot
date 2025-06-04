#!/bin/bash

# Prompt for directory
read -rp "Enter the path to the directory containing MIDI files: " midi_dir

# Validate directory
if [[ ! -d "$midi_dir" ]]; then
    echo "Error: '$midi_dir' is not a valid directory."
    exit 1
fi

cd "$midi_dir" || exit 1

# Find and sort MIDI files
midi_files=(*.mid *.midi)
if [[ ${#midi_files[@]} -eq 0 ]]; then
    echo "No MIDI files found in: $midi_dir"
    exit 1
fi

# Play each file
for midi in "${midi_files[@]}"; do
    [[ -f "$midi" ]] || continue
    echo "Now playing: $midi"

    timidity "$midi" 2>&1 | tee /tmp/timidity_log.txt

    if grep -q 'Text: Dauer:' /tmp/timidity_log.txt; then
        duration=$(grep 'Text: Dauer:' /tmp/timidity_log.txt)
        echo "Duration: ${duration#Text: }"
    fi

    echo "Waiting 2 seconds before next track..."
    sleep 2
done

echo "All files played."
