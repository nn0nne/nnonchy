#!/usr/bin/env bash

update_window_counts_info() {
    active_workspace_status=()

    get_mmsg_tag_array=($(mmsg -gt))
    get_mmsg_layout=($(mmsg -gl))

    layout=${get_mmsg_layout[2]}

    active_workspaces_status_index=(5 11 17 23 29 35 41 47 53)
    active_workspaces_window_counts_index=(4 10 16 22 28 34 40 46 52)

    for w in "${active_workspaces_status_index[@]}"; do
        active_workspace_status+=("${get_mmsg_tag_array[$w]}")
    done

    if [[ $layout == "S" ]]; then
        for i in {0..8}; do
            if [[ "${active_workspace_status[$i]}" == "1" ]]; then
                printf '{"text": "%s"}' "${get_mmsg_tag_array[${active_workspaces_window_counts_index[$((i))]}]}"
            fi
        done
    fi
}

mmsg -w | while read -r event; do
    update_window_counts_info
    stdbuf -oL echo
done
