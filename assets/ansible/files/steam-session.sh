#!/bin/bash
STEAM_ARGS="-tenfoot -steamos -enableremoteplay"
xset s off -dpms
xset s noblank
exec gamemoderun /usr/games/steam $STEAM_ARGS