#!/usr/bin/env bash

(mmsg -gl; mmsg -gt) | awk '
    # Function to print in yambar format
    function print_bar() {
        if (ws != "" && layout != "") {
            out = "| " ws "| " 
            if (layout == "S" && active_clients > 1) {
                out = out "󰕰 " layout " (" active_clients ")"
            } else {
                out = out "󰙀 " layout
            }

            # Only print if the final string actually changed
            if (out != last_out) {
                # Yambar format: name|type|value
                print "mmsg_info|string|" out
                # Mandatory empty line to commit the transaction
                print ""
                fflush()
                last_out = out
            }
        }
    }

    {
        if ($2 == "layout") {
            layout = $3
            print_bar()
        }
        
        if ($2 == "tag") {
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
