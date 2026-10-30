function push_qt
    set -l remote_bin /appfs/qt.bin
 #   set -l remote_bin /tmp/sd/qt.bin

    echo "📤 Pushing qt.bin..."
    adb push Build-arm/qt.bin $remote_bin || begin
        echo "❌ Push failed"
        return 1
    end

    echo "💀 Stopping old process..."
    adb shell "pkill -f qt.bin || true"

    echo "🚀 Launching qt.bin..."
    adb shell "nohup $remote_bin >/dev/null 2>&1 &"

    echo "✅ Done."
end


