#!/system/bin/sh
MODDIR=${0%/*}

# Magisk Service Script for Optimization
# Reset props after boot completed to avoid breaking some weird devices/ROMs..
write() {
	[[ ! -f "$1" ]] && return 1
	chmod +w "$1" 2> /dev/null
	if ! echo "$2" > "$1" 2> /dev/null
	then
		echo "Failed: $1 → $2"
		return 1
	fi
}

AuthName=$(grep "author=@REALHARD" $MODDIR/module.prop) > /dev/null 2>&1;
if ([ "$AuthName" == "author=@REALHARD" ]); then
	Launch="@REALHARD";
else
	Launch="Please give credit to https://t.me/PROJECT_REALHARD";
fi;

sleep 20

# Change I/O Optimize
for queue in /sys/block/*/queue
do
    echo 0 > "$queue/iostats"
    echo deadline > "$queue/scheduler"
    echo 0 > "$queue/rq_affinity"
    #echo 512 > "$queue/read_ahead_kb"
done

# Setting Load highspeed
for gov in /sys/devices/system/cpu/*/cpufreq/*
do
   echo 95 > "$gov/hispeed_load"
   echo 1 > "$gov/boost"
done

echo 0 > /sys/devices/system/cpu/cpu0/core_ctl/enable

# Force Thermal Dynamic Evaluation
if [ -e /sys/class/thermal/thermal_message/sconfig ]; then
      chmod 644 /sys/class/thermal/thermal_message/sconfig
      echo "10" > /sys/class/thermal/thermal_message/sconfig
      chmod 444 /sys/class/thermal/thermal_message/sconfig
    fi

# UFSPerformance
#echo performance > /sys/class/devfreq/1d84000.ufshc/governor

# Stop thermal Service
#for a in $(getprop|grep thermal|cut -f1 -d]|cut -f2 -d[|grep -F init.svc.|sed 's/init.svc.//');do stop $a;done;for b in $(getprop|grep thermal|cut -f1 -d]|cut -f2 -d[|grep -F init.svc.);do setprop $b stopped;done;for c in $(getprop|grep thermal|cut -f1 -d]|cut -f2 -d[|grep -F init.svc_);do setprop $c "";done

# Other commands or settings if required
su -c settings put global touch_response_time 0
su -c settings put global foreground_ram_priority high
su -c cmd power set-fixed-performance-mode-enabled true
su -c cmd thermalservice override-status 0
su -c settings put system power_mode high
su -c settings put system speed_mode 1
su -c settings put secure speed_mode_enable 1
su -c settings put system thermal_limit_refresh_rate 0
su -c settings put system link_turbo_option 1
su -c settings put global block_untrusted_touches 0

# Increase RenderThread Priority
renice -n -16 -p $(pidof RenderThread) 2>/dev/null

# ข้อความ
su -lp 2000 -c "cmd notification post -S bigtext -t '🔥TWEAK🔥' 'Tag' 'VTEC_Dynamic ⚡ปรับแต่ง⚡ Impover Overall Stability Successfull @RealHard️'"

# Enable Fast Charge for slightly faster battery charging when being connected to a USB 3.1 port
echo 1 > /sys/kernel/fast_charge/force_fast_charge

# Disable scheduler statistics to reduce overhead
write /proc/sys/kernel/sched_schedstats 0

# We are not concerned with prioritizing latency
write /dev/stune/top-app/schedtune.prefer_idle 0

# Mark top-app as boosted, find high-performing CPUs
write /dev/stune/top-app/schedtune.boost 1

# Multiplier
echo 4 > /proc/sys/kernel/sched_pelt_multiplier

# ปิดการลดความเร็ว CPU/GPU ขณะใช้งานหนัก (ลดการกระตุก)
echo "0" > /sys/devices/system/cpu/cpu*/cpufreq/*/down_rate_limit_us
echo "0" > /sys/devices/system/cpu/cpu*/cpufreq/*/up_rate_limit_us

# เพิ่ม GPU Priority และลด Latency
echo "3" > /proc/sys/kernel/sched_child_runs_first
echo "0" > /proc/sys/kernel/nmi_watchdog
echo "100" > /proc/sys/vm/swappiness

# Force GPU rendering in apps
settings put global force_gpu_rendering 1

# Script
nohup sh $MODDIR/script/shellscript > /dev/null &

# Applied changes
echo "Optimization applied successfully!"
