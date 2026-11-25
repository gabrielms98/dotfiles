#!/bin/bash
# Bring a Finder window to the focused workspace, focus it and center it on screen.
# Opens a new Finder window when none exists.
export PATH="/opt/homebrew/bin:$PATH"

workspace=$(aerospace list-workspaces --focused)
window_id=$(aerospace list-windows --monitor all --app-bundle-id com.apple.finder --format '%{window-id}' | head -n 1)

if [ -z "$window_id" ]; then
  osascript -e 'tell application "Finder"' -e 'make new Finder window' -e 'activate' -e 'end tell'
  exit 0
fi

aerospace move-node-to-workspace --window-id "$window_id" "$workspace"
aerospace focus --window-id "$window_id"

# AeroSpace can leave a floating window parked off-screen in its hiding corner,
# so put the now-frontmost Finder window back in the middle of the screen.
osascript -l JavaScript <<'JS'
ObjC.import("AppKit");
const screen = $.NSScreen.mainScreen;
const full = screen.frame, vis = screen.visibleFrame;
// AppleScript bounds use a top-left origin; Cocoa uses bottom-left.
const top = full.size.height - (vis.origin.y + vis.size.height);
const finder = Application("Finder");
const win = finder.finderWindows[0];
const cur = win.bounds();
const w = Math.min(cur.width, vis.size.width), h = Math.min(cur.height, vis.size.height);
const x = Math.round(vis.origin.x + (vis.size.width - w) / 2);
const y = Math.round(top + (vis.size.height - h) / 2);
win.bounds = {x: x, y: y, width: w, height: h};
JS
