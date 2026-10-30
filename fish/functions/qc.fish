function qc --description "Pick a quick command (fzf)"
    set -l dir $HOME/.config/snippets
    set -l files (path filter --type file -- $dir/*.cheat 2>/dev/null)
    if test (count $files) -eq 0
        printf 'qc: no snippets found in %s\n' $dir >&2
        return 1
    end

    set -l opts --delimiter "§" --with-nth 1 --exact --reverse --height 60% \
        --prompt "QC> " \
        --header "Enter=insert  Ctrl-E=run  Esc=cancel" \
        --preview "sed -n '{3},{4}p' '{2}'" \
        --preview-window "down:45%:wrap" \
        --expect enter,ctrl-e

    set -l token (commandline -ct 2>/dev/null)
    if test -n "$token"
        set opts $opts --query "$token"
    end

    set -l out (awk -f $dir/list.awk $files | fzf $opts)
    if test (count $out) -lt 2
        return 0
    end

    set -l parts (string split "§" -- $out[2])
    set -l cmd $parts[5]
    if test -z "$cmd"
        return 0
    end

    if test "$out[1]" = ctrl-e
        commandline -r -- $cmd
        commandline -f execute
    else if commandline -i -- $cmd
        commandline -f repaint
    else
        echo $cmd
    end
end
