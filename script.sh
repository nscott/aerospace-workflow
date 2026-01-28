#!/usr/bin/env bash

export PATH="/opt/homebrew/bin:$PATH"

# References:
# - https://nikitabobko.github.io/AeroSpace/commands#list-windows
# - https://www.alfredapp.com/help/workflows/inputs/script-filter/json/
# - https://github.com/yuriteixeira/aerospace-workflow
aerospace list-windows --all --format "%{app-pid} %{window-id} %{app-name} %{window-title}" | \
while read -r appPid windowId appName windowTitle; do
  appPath="$(ps -o comm= -p "$appPid")"
  bundlePath="${appPath%%\.app*}.app"

  jq -n \
    --arg title "$appName" \
    --arg subtitle "$windowTitle" \
    --arg match "$appName | $windowTitle" \
    --arg arg "$windowId" \
    --arg path "$bundlePath" \
    '{
      title: $title,
      subtitle: $subtitle,
      match: $match,
      arg: $arg,
      icon: { type: "fileicon", path: $path }
    }'
done | jq -s '{ items: . }'
