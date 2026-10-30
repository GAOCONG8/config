# Parse navi-style .cheat files into fzf candidates.
# Output fields (separated by §):
#   display  file  start  end  command
# command lines are joined with "; " for execution/insertion.

function emit() {
    if (open) {
        printf "%s§%s§%d§%d§%s\n", disp, file, start, start + ncmd - 1, cmd
    }
    open = 0
    ncmd = 0
    cmd = ""
}

FNR == 1 {
    emit()
    file = FILENAME
}

/^%/ {
    emit()
    header = $0
    sub(/^%[ \t]*/, "", header)
    if (index(header, ",")) {
        name = substr(header, 1, index(header, ",") - 1)
        tags = substr(header, index(header, ",") + 1)
    } else {
        name = header
        tags = ""
    }
    gsub(/^[ \t]+/, "", name); gsub(/[ \t]+$/, "", name)
    gsub(/^[ \t]+/, "", tags); gsub(/[ \t]+$/, "", tags)
    disp = tags == "" ? name : name "  (" tags ")"
    start = FNR
    open = 1
    next
}

/^[ \t]*#/ { next }
/^[ \t]*$/ { emit(); next }

{
    if (open) {
        cmd = ncmd == 0 ? $0 : cmd "; " $0
        ncmd++
    }
}

END { emit() }
