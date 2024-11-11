#!/usr/bin/env nu

use ./is_nvim_running.nu

def main [tempfile: path] {
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
        print $tempfile
        zellij action write-chars $"\u{1B}:copen\u{0D}:cgetfile ($tempfile)\u{0D}"
    } else {
        zellij run -- $"nvim -q ($tempfile)"
    }

    # Move focus back to float
    zellij action toggle-floating-panes
    zellij action close-pane
}
