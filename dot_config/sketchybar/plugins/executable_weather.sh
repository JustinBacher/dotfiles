#!/usr/bin/env zsh

IP=$(curl -s https://ipinfo.io/ip)
LOCATION_JSON=$(curl -s https://ipinfo.io/$IP/json)

LOCATION="$(echo $LOCATION_JSON | jq '.city' | tr -d '"')"
REGION="$(echo $LOCATION_JSON | jq '.region' | tr -d '"')"
COUNTRY="$(echo $LOCATION_JSON | jq '.country' | tr -d '"')"

# Line below replaces spaces with +
LOCATION_ESCAPED="${LOCATION// /+}+${REGION// /+}"
WEATHER_DESC=$(curl -s "https://wttr.in/$LOCATION_ESCAPED?format=%c%C+%F0%9F%8C%A1%EF%B8%8F%f+%F0%9F%92%A7%h+%w%F0%9F%92%A8" | tr -d +)


# Fallback if empty
if [ -z $WEATHER_DESC ]; then

    sketchybar --set $NAME label=$LOCATION
    return
fi

sketchybar --set $NAME label="$WEATHER_DESC"
