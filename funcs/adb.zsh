function adb-root-remount() {
    adb root && adb wait-for-device && adb remount
}

function adb-select()
{
    echo "Select the device to set as ANDROID_SERIAL:";
    device_list=($(adb devices | grep "device$"|cut -f1));
    UNSET="Unset ANDROID_SERIAL";
    device_list+=("$UNSET");
    select device in "${device_list[@]}";
    do
        if [ "$device" = "$UNSET" ]; then
            echo "Unsetting ANDROID_SERIAL";
            unset ANDROID_SERIAL;
            unset FASTBOOT_SERIAL;
        else
            echo "Setting ANDROID_SERIAL=$device";
            export ANDROID_SERIAL=$device;
            export FASTBOOT_SERIAL=$device;
        fi;
        break;
    done
}

function adb-reboot() {
    adb reboot
    echo "waiting to complete..."
    adb wait-for-device
    A=$(adb shell getprop sys.boot_completed | tr -d '\r')
    while [ "$A" != "1" ]; do
        sleep 2
	A=$(adb shell getprop sys.boot_completed | tr -d '\r')
    done
    adb shell input keyevent 82
}

