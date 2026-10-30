function adbN
    set -l idx 1
    if string match -qr '^[0-9]+$' -- $argv[1]
        set idx $argv[1]
    end

    set -l raw (adb devices | string trim | string match -rv '^(List|$)')
    if test -z "$raw"
        echo "no devices connected" >&2
        return 1
    end

    set -l serials
    for line in $raw
        set -a serials (string match -r '^\S+' -- $line)
    end

    set -l target $serials[$idx]
    if test -z "$target"
        echo "device index $idx not found (only "(count $serials)" online)" >&2
        return 1
    end

    echo "# adb -s $target shell"
    adb -s $target shell
end
