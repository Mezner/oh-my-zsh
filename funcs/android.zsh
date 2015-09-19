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
        $ANDROID_SDK_TOOLS_PATH/emulator-x86 -avd $1 -netspeed full -netdelay none $2 &
    fi
}

function android-avd-list {
    $ANDROID_SDK_TOOLS_PATH/emulator-x86 -list-avds
}

function android-signed {
    keytool -list -printcert -jarfile $1
}

function android-packages {
    adb shell pm list packages -f $1
}

android-avd-list > ~/.androiddevices

_android_avd_start() {
    compadd -X "=== Android Devices ===" `cat ~/.androiddevices`
}

compdef _android_avd_start android-avd-start
