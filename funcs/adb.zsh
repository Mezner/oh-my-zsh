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
