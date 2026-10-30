function push_HLSysMng
    set -l remote_bin /appfs/HLSysMng.bin

    echo "📤 Pushing qt.bin..."
    adb push HLSysMng.bin $remote_bin || begin
        echo "❌ Push failed"
        return 1
    end
    adb shell "chmod +x /appfs/HLSysMng.bin"
    adb shell "sync && reboot"

    echo "✅ Done."
end

