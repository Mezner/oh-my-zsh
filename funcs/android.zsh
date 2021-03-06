function android-dump-badging() {
    aapt dump badging $1
}

function android-developmentsettings() {
    adb shell am start -am com.android.settings/.DevelopmentSettings
}

function clearlog()
{
    adb lolcat -c
}

function android-alllogs() {
    adb logcat -v threadtime -b main -d > log-main.txt
    adb logcat -v threadtime -d > log-merged_default.txt
    adb logcat -v threadtime -b radio -d > log-radio.txt
    adb logcat -v threadtime -b events -d > log-events.txt
}

function mezlog()
{
    while true
    do
        adb logcat -v threadtime -s "MEZ:V AndroidRuntime:E System.err:W *:S"
        sleep 2
    done
}

function mezlog-out()
{
    adb lolcat -v threadtime -d -s "MEZ:V AndroidRuntime:E *:S"
}

function gclog()
{
    while true
    do
        adb logcat -v threadtime -s "MEZ:V AndroidRuntime:E dalvikvm:D *:S"
        sleep 2
    done
}

function logandroidruntime()
{
    adb logcat -v time -s "AndroidRuntime,MEZ"
}

function android-stop {
    echo "stopping $1"
    adb shell am force-stop $1
}

function android-kill {
    pid=$(adb shell ps | grep "$1" | awk '{print $2}')
    echo "Killing PID: $pid"
    adb shell kill $pid
}

function android-restart {
    adb shell stop; adb shell start
}

export SYSTRACE_LOCATION=~/adt/sdk/platform-tools/systrace/systrace.py
function android-set-systrace-42 {
    python $SYSTRACE_LOCATION --set-tags gfx,view,wm
    android-restart
}

function android-systrace {
    python $SYSTRACE_LOCATION --disk --time=$1 -o $2
    if [ ! -z $3 ]
    then
        open $2
    fi
}

function dumpheap {
    adb shell am dumpheap $1 /sdcard/$2
    adb pull /sdcard/$2
    hprof-conv $2 converted.hprof
    mv converted.hprof $2
}

function android-avd-start {
    if [ -z $1 ]
    then
        echo "syntax: android-avd-start <AVD_NAME>"
        echo ""
        android-avd-list
    fi
    if [ ! -z $1 ]
    then
        $ANDROID_SDK_TOOLS_PATH/emulator-x86 -avd $1 -netspeed full -netdelay none -gpu off $2 &
    fi
}

function android-avd-list {
    $ANDROID_SDK_TOOLS_PATH/emulator-x86 -list-avds
}

function android-signed {
    keytool -list -printcert -jarfile $1
}

function android-remove {
    android-root-and-remount
    files = (${adb shell pm list packages -f $1 | sed 's/package:\(.*\)=.*/\1/'})
    for file ($files); do
        echo "removing $file..."
        adb pull $file $ADB_PULL_LOCATION
	adb shell rm $file
    done
    echo "rebooting..."
    adb reboot
}

function android-root-and-remount() {
    echo "rooting and remounting..."
    adb root && adb remount
}

function android-packages {
    adb shell pm list packages -f $1
}

function android-screenshot {
	adb shell /system/bin/screencap -p /sdcard/screenshot.png
	adb pull /sdcard/screenshot.png screenshot.png
}

function android-restart-soft {
    adb shell stop && adb shell start
}

# android-avd-list > ~/.androiddevices

_android_avd_start() {
    compadd -X "=== Android Devices ===" `cat ~/.androiddevices`
}

compdef _android_avd_start android-avd-start
