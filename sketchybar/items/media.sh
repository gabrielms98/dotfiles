#!/bin/bash

sketchybar --add item media e \
           --set media label.color=$BAR_COLOR \
                       label.max_chars=30 \
                       icon.padding_left=0 \
                       scroll_texts=on \
                       icon=􀑪             \
                       icon.color=$BAR_COLOR   \
                       background.drawing=off \
                       script="$PLUGIN_DIR/media.sh" \
                       position=right \
           --subscribe media media_change
