#!/usr/bin/env bash

(mmsg -gl; mmsg -gt) | awk '
    # Function to print the bar whenever data changes
    function print_bar() {
        if (ws != "" && layout != "") {
            out = " | " ws " | " 
            if (layout == "S" && active_clients > 1) {
                out = out "󰕰 " layout " (" active_clients ") | "
            } else {
                out = out "󰙀 " layout " | "
            }
            # Only print if the final string actually changed
            if (out != last_out) {
                print out
                fflush()
                last_out = out
            }
        }
    }

    # Every time mmsg outputs a line, awk processes it
    {
        # If the line contains layout info
        if ($2 == "layout") {
            layout = $3
            print_bar()
        }
        
        # If the line contains tag info
        if ($2 == "tag") {
            # We need to clear the state and rebuild based on the current snapshot
            # To do this efficiently, we grab the latest snapshot every time a tag event occurs
            cmd = "mmsg -gt"
            ws = ""
            active_clients = 0
            while ((cmd | getline line) > 0) {
                split(line, a)
                if (a[2] == "tag") {
                    if (a[4] == 1) {
                        ws = ws "[" a[3] "] "
                        active_clients += a[5]
                    } else if (a[5] > 0) {
                        ws = ws a[3] "* "
                    }
                }
            }
            close(cmd)
            print_bar()
        }
    }
'
# last_output=""
#
# generate_bar() {
#     # We pipe both commands into one AWK process
#     # 1. Get layout
#     # 2. Get tags
#     final_output=$( (mmsg -gl; mmsg -gt) | awk '
#         # Record the layout name from mmsg -gl
#         $2 == "layout" { layout = $3 }
#
#         # Process tag lines from mmsg -gt
#         $2 == "tag" {
#             tag_id = $3
#             is_active = $4
#             has_clients = $5
#
#             # Build the workspace string
#             if (is_active == 1) {
#                 ws = ws "[" tag_id "]"
#                 # Sum clients ONLY if tag is active
#                 active_clients += has_clients
#             } else if (has_clients > 0) {
#                 ws = ws tag_id "*"
#             }
#         }
#
#         END {
#             # Format the layout section
#             if (layout == "S" && active_clients > 1) {
#                 layout_info = "󰕰 " layout " (" active_clients ")"
#             } else {
#                 layout_info = "󰙀 " layout
#             }
#
#             # Print the final bar string
#             printf " | %s | %s | \n", ws, layout_info
#         }
#     ')
#
#     if [[ "$final_output" != "$last_output" ]]; then
#         echo "$final_output"
#         last_output="$final_output"
#     fi
# }
#
# # Initial run
# generate_bar
#
# # Watch for events
# mmsg -wtl | while read -r _; do
#     generate_bar
# done
