#!/usr/bin/env bash
# Themed wofi Wi-Fi menu — pick a network and connect (prompts for password if needed).
# Bound to Super+W and the waybar network icon. Uses NetworkManager (nmcli).

notify() { command -v notify-send >/dev/null 2>&1 && notify-send -a "Wi-Fi" "$1" "${2:-}"; }
wifi_dev() { nmcli -t -f DEVICE,TYPE dev | awk -F: '$2=="wifi"{print $1; exit}'; }

# make sure the radio is on
[ "$(nmcli -t -f WIFI radio 2>/dev/null)" = "disabled" ] && { nmcli radio wifi on; sleep 2; }

nmcli -t dev wifi rescan >/dev/null 2>&1
sleep 1

active=$(nmcli -t -f ACTIVE,SSID dev wifi 2>/dev/null | awk -F: '$1=="yes"{print $2; exit}')

# one line per SSID (strongest dup kept): <signal-icon>  SSID [lock]
list=$(nmcli -t -f SIGNAL,SECURITY,SSID dev wifi list 2>/dev/null | awk -F: '
  $3=="" || seen[$3]++ { next }
  {
    s=$1
    if (s>=75) ic="󰤨"; else if (s>=50) ic="󰤥"; else if (s>=25) ic="󰤢"; else ic="󰤟"
    lock=($2=="" || $2=="--") ? "" : "  "
    printf "%s  %s%s\n", ic, $3, lock
  }')

menu=""
[ -n "$active" ] && menu+="󰖪  Disconnect ($active)"$'\n'
menu+="$list"$'\n'"󰑓  Rescan"$'\n'"  Connection editor"

chosen=$(printf "%s" "$menu" | wofi --dmenu --insensitive --prompt "Wi-Fi" --width 380 --height 430)
[ -z "$chosen" ] && exit 0

case "$chosen" in
  *"Disconnect ("*) nmcli dev disconnect "$(wifi_dev)" && notify "Disconnected"; exit 0 ;;
  "󰑓  Rescan")       exec "$0" ;;
  *"Connection editor") setsid -f nm-connection-editor >/dev/null 2>&1; exit 0 ;;
esac

# strip leading icon + trailing lock marker → bare SSID
ssid=$(printf "%s" "$chosen" | sed -E 's/^[^ ]+  //; s/  +$//')

# already saved? just bring it up
if nmcli -t -f NAME connection show | grep -Fxq "$ssid"; then
  nmcli connection up id "$ssid" && notify "Connected" "$ssid" || notify "Failed" "$ssid"
  exit 0
fi

sec=$(nmcli -t -f SSID,SECURITY dev wifi list | awk -F: -v s="$ssid" '$1==s{print $2; exit}')
if [ -z "$sec" ] || [ "$sec" = "--" ]; then
  nmcli dev wifi connect "$ssid" && notify "Connected" "$ssid" || notify "Failed" "$ssid"
else
  pass=$(printf "" | wofi --dmenu --password --prompt "Password: $ssid" --width 380 --height 120)
  [ -z "$pass" ] && exit 0
  nmcli dev wifi connect "$ssid" password "$pass" && notify "Connected" "$ssid" || notify "Wrong password?" "$ssid"
fi
