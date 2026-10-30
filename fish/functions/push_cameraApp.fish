function push_cameraApp
    set -l remote_bin /customer/bin/cameraApp

    echo "🔪 Killing existing cameraApp..."
    adb shell "killall cameraApp 2>/dev/null; true"

    echo "📤 Pushing cameraApp..."
    adb push build/bin/cameraApp $remote_bin || begin
        echo "❌ Push failed"
        return 1
    end

    echo "✅ Done."
end
