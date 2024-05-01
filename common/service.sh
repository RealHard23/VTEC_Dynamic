#!/system/bin/sh
MODDIR=${0%/*}

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

sleep 20

# Change I/O Optimize
for queue in /sys/block/*/queue
do
    echo 0 > "$queue/iostats"
    echo deadline > "$queue/scheduler"
    echo 0 > "$queue/rq_affinity"
    #echo 1024 > "$queue/read_ahead_kb"
done

# UFSPerformance
echo performance > /sys/class/devfreq/1d84000.ufshc/governor

# Force Thermal Dynamic Evaluation
chmod 0777 /sys/class/thermal/thermal_message/sconfig
echo 10 > /sys/class/thermal/thermal_message/sconfig
chmod 0444 /sys/class/thermal/thermal_message/sconfig

# Disable temp* thermal zone
for zone in /sys/class/thermal/thermal_zone*; do
    if [[ -d "$zone" ]]; then
        echo "Disabling temp in $zone"
        chmod a-r "$zone"/temp
    fi
done

# Other commands or settings if required
su -c settings put system miui_app_cache_optimization 1
su -c settings put global touch_response_time 0
su -c settings put global foreground_ram_priority high
su -c settings put global private_dns_mode opportunistic
su -c settings put global smart_network_speed_distribution 1
su -c settings put global use_data_network_accelerate 1
su -c settings put global animator_duration_scale 0.0024999
su -c settings put global transition_animation_scale 0.0024999
su -c settings put global window_animation_scale 0.0024999
su -c cmd power set-fixed-performance-mode-enabled true
su -c cmd thermalservice override-status -1
su -c settings put system power_mode high
#su -c settings put system speed_mode 1
su -c settings put secure speed_mode_enable 1
#su -c settings put secure thermal_temp_state_value 0
su -c settings put system thermal_limit_refresh_rate -1
su -c settings put system link_turbo_option 1
su -c settings put global transition_animation_duration_ratio 0.0024999
su -c settings put global block_untrusted_touches 0

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
# echo 1 > /sys/class/kgsl/kgsl-3d0/thermal_pwrlevel

# Script
nohup sh $MODDIR/script/shellscript > /dev/null &
sync && echo 3 > /proc/sys/vm/drop_caches
echo "Optimizations applied successfully!"

# Disable other unnecessary debugging options as per your needs
exit 0