#!/usr/bin/env nu

export def main [list_clients_output: string] {
    let cmd = $list_clients_output | str trim | str downcase
    
    # Split the command into parts
    let parts = $cmd | split row " "
    
    # Check if any part ends with 'nvim' or is 'nvim'
    let has_nvim = ($parts | any {|part| $part | str ends-with "/nvim"})
    let is_nvim = ($parts | any {|part| $part == "nvim"})
    let has_or_is_nvim = $has_nvim or $is_nvim
    
    # Find the position of 'nvim' in the parts
    let nvim_positions = ($parts | enumerate | where {|x| ($x.item == "nvim" or ($x.item | str ends-with "/nvim"))} | get index)
    
    # Check if 'nvim' is the first part or right after a path
    let is_nvim_at_start = if ($nvim_positions | is-empty) {
        false
    } else {
        let nvim_position = $nvim_positions.0
        $nvim_position == 0 or ($nvim_position > 0 and ($parts | get ($nvim_position - 1) | str ends-with "/"))
    }
    
    let result = $has_or_is_nvim and $is_nvim_at_start
    
    # Debug information
    let debug_info = {
      input: {
        list_clients_output: ($list_clients_output)
      },
      'treated input': {
        cmd: ($cmd),
        parts: ($parts),
        has_nvim: ($has_nvim),
        is_nvim: ($is_nvim),
        has_or_is_nvim: ($has_or_is_nvim),
        nvim_positions: ($nvim_positions),
        is_nvim_at_start: ($is_nvim_at_start),
        'Final result': ($result),
      }
    }
    print $debug_info
    
    $result
}

