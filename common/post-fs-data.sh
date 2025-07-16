#!/system/bin/sh
MODDIR=${0%/*}

# Optimization
{
while true; do
        #resetprop  -n persist.sys.power.default.powermode high
        resetprop  -n persist.sys.turbosched.enable true
        resetprop  -n persist.sys.turbosched.enable.coreApp.optimizer true
        sleep 1;
    done
} &

