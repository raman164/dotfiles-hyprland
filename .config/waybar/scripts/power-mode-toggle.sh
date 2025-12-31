#!/bin/bash
# Waybar power mode toggle - uses direct CPU control

STATE_FILE="/tmp/power-mode-state"

get_current_mode() {
    # Check turbo boost status (most reliable indicator)
    local turbo=$(cat /sys/devices/system/cpu/intel_pstate/no_turbo 2>/dev/null)

    if [ "$turbo" = "1" ]; then
        echo "battery"
    else
        echo "performance"
    fi
}

set_performance_mode() {
    # Enable turbo boost
    echo "0" | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo > /dev/null 2>&1

    # Set performance governor
    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
        [ -f "$cpu" ] && echo "performance" | sudo tee "$cpu" > /dev/null 2>&1
    done

    # Set energy preference to performance
    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference; do
        [ -f "$cpu" ] && echo "performance" | sudo tee "$cpu" > /dev/null 2>&1
    done

    echo "performance" > "$STATE_FILE"
    notify-send "Power Mode" "Performance Mode Enabled" -t 2000 -i cpu
}

set_battery_mode() {
    # Disable turbo boost
    echo "1" | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo > /dev/null 2>&1

    # Set powersave governor
    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
        [ -f "$cpu" ] && echo "powersave" | sudo tee "$cpu" > /dev/null 2>&1
    done

    # Set energy preference to power
    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference; do
        [ -f "$cpu" ] && echo "power" | sudo tee "$cpu" > /dev/null 2>&1
    done

    echo "battery" > "$STATE_FILE"
    notify-send "Power Mode" "Battery Saving Mode Enabled" -t 2000 -i battery
}

case "$1" in
    "toggle")
        current_mode=$(get_current_mode)
        if [ "$current_mode" = "performance" ]; then
            set_battery_mode
        else
            set_performance_mode
        fi
        sleep 0.5  # Give system time to apply changes
        ;;
    *)
        # Output for waybar
        mode=$(get_current_mode)
        if [ "$mode" = "performance" ]; then
            echo '{"text": "󱐋", "tooltip": "Performance Mode (click to save battery)", "class": "performance"}'
        else
            echo '{"text": "󰾅", "tooltip": "Battery Saving Mode (click for performance)", "class": "battery"}'
        fi
        ;;
esac
