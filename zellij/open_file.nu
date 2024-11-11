#!/usr/bin/env nu

use ./is_nvim_running.nu

def main [file_path: path, location?: string] {
    # NOTE: This runs on the assumption that the calling process is in a floating pane
    zellij action toggle-floating-panes
    # Store the second line of the zellij clients list in a variable
    let list_clients_output = (zellij action list-clients | lines | get 1)

    # Parse the output to remove the first two words and extract the rest
    let running_command = $list_clients_output 
        | parse --regex '\w+\s+\w+\s+(?<rest>.*)'  # Use regex to match two words and capture the remaining text as 'rest'
        | get rest  # Retrieve the captured 'rest' part, which is everything after the first two words
        | to text

    # Check if the command running in the current pane is hx
    if (is_nvim_running $running_command) {
        # The current pane is running hx, use zellij actions to open the file
        print $file_path
        print $location
        zellij action write-chars $"\u{1B}:e ($file_path)\u{0D}"
        if (not ($location | is-empty)) {
            zellij action write-chars $"\u{1B}($location)G"
        }
    } else {
        # Determine the working directory
        let working_dir = if ($file_path | path exists) and ($file_path | path type) == "dir" {
            $file_path
        } else {
            $file_path | path dirname
        }
        zellij run --cwd $working_dir -- $"nvim ($file_path) ($location)"
    }

    # Move focus back to float
    zellij action toggle-floating-panes
    zellij action close-pane
}
