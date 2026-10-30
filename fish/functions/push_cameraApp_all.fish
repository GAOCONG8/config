function push_cameraApp_all
    set -l remote_bin /customer/bin/cameraApp
    set -l local_bin build/bin/cameraApp
    if test (count $argv) -ge 1
        set local_bin $argv[1]
    end

    if not test -f $local_bin
        echo "❌ Local binary '$local_bin' not found!"
        return 1
    end

    set -l devices (adb devices | awk 'NR>1 && $2 ~ /^(device|host)$/ {print $1}')
    if test (count $devices) -eq 0
        echo "❌ No devices attached!"
        return 1
    end

    echo "📱 Found "(count $devices)" device(s): "(string join ", " $devices)

    set -l failed 0
    for dev in $devices
        echo ""
        echo "========================================"
        echo "📱 Processing device: $dev"
        echo "========================================"

        echo "🔪 Killing existing cameraApp on $dev..."
        adb -s $dev shell "killall cameraApp 2>/dev/null; true"

        echo "📤 Pushing cameraApp to $dev..."
        if not adb -s $dev push $local_bin $remote_bin
            echo "❌ Push to $dev failed"
            set failed (math $failed + 1)
            continue
        end

        echo "✅ $dev updated successfully."
    end

    echo ""
    if test $failed -eq 0
        echo "🎉 All devices updated successfully!"
    else
        echo "⚠️ Completed with $failed failure(s)."
        return 1
    end
end
