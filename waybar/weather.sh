#!/bin/bash

# Check network connectivity
if ! ping -c 1 -W 1 8.8.8.8 >/dev/null 2>&1; then
  echo "{\"text\":\"\", \"tooltip\":\"No internet connection\"}"
  exit 0
fi

# Weather script logic here
API_KEY="3d8b68e5460cb38ee8d4ab9d0c6fa0dc"
CITY="Richmond Hill"
UNITS="metric"

weather=$(curl -s "https://api.openweathermap.org/data/2.5/weather?q=${CITY}&appid=${API_KEY}&units=${UNITS}")

if [ $? -ne 0 ] || [ -z "$weather" ]; then
  echo "{\"text\":\"\", \"tooltip\":\"Unable to fetch weather\"}"
  exit 1
fi

temperature=$(echo "$weather" | jq ".main.temp" | xargs printf "%.0f")
condition=$(echo "$weather" | jq -r ".weather[0].main")

case $condition in
  Clear) icon="";;
  Clouds) icon="";;
  Rain) icon="";;
  Drizzle) icon="";;
  Thunderstorm) icon="";;
  Snow) icon="";;
  Mist|Fog|Haze) icon="";;
  *) icon="";;
esac

echo "{\"text\":\"${icon} ${temperature}°\", \"tooltip\":\"${condition}\"}"

