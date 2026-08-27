#!/usr/bin/env bash
# Minimalist Wayland Screen & Audio Recorder Script (wf-recorder)

SAVE_DIR="$HOME/Videos/Recordings"
PID_FILE="/tmp/wf-recorder.pid"
mkdir -p "$SAVE_DIR"

# If wf-recorder is already running, stop recording cleanly
if pgrep -x "wf-recorder" > /dev/null; then
    # Send SIGINT to properly finalize MP4 container
    killall -s SIGINT wf-recorder 2>/dev/null
    sleep 0.5

    # Retrieve last recorded file path
    LAST_RECORDING=$(ls -t "$SAVE_DIR"/recording_*.mp4 2>/dev/null | head -n 1)
    if [ -n "$LAST_RECORDING" ] && [ -f "$LAST_RECORDING" ]; then
        FILE_SIZE=$(du -h "$LAST_RECORDING" | cut -f1)
        notify-send -a "Screen Recorder" -i "media-record" "Recording Saved" "$(basename "$LAST_RECORDING") ($FILE_SIZE)"
    else
        notify-send -a "Screen Recorder" -i "media-record" "Recording Stopped" "Recording finished successfully"
    fi
    exit 0
fi

# Prepare new recording timestamp and filepath
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
FILE_PATH="$SAVE_DIR/recording_$TIMESTAMP.mp4"

# Handle recording modes
case "$1" in
    full)
        notify-send -a "Screen Recorder" -i "media-record" "Recording Started" "Fullscreen (Super+Alt+R to stop)"
        wf-recorder -f "$FILE_PATH" -c h264_vaapi -d /dev/dri/renderD128 2>/dev/null || wf-recorder -f "$FILE_PATH" -c libx264 2>/dev/null &
        ;;
    full-audio)
        notify-send -a "Screen Recorder" -i "media-record" "Recording Started" "Fullscreen with Audio (Super+Alt+R to stop)"
        wf-recorder --audio -f "$FILE_PATH" -c h264_vaapi -d /dev/dri/renderD128 2>/dev/null || wf-recorder --audio -f "$FILE_PATH" -c libx264 2>/dev/null &
        ;;
    area-audio)
        GEOM=$(slurp)
        if [ -n "$GEOM" ]; then
            notify-send -a "Screen Recorder" -i "media-record" "Recording Started" "Selected Area with Audio (Super+Alt+R to stop)"
            wf-recorder -g "$GEOM" --audio -f "$FILE_PATH" -c h264_vaapi -d /dev/dri/renderD128 2>/dev/null || wf-recorder -g "$GEOM" --audio -f "$FILE_PATH" -c libx264 2>/dev/null &
        fi
        ;;
    area|*)
        GEOM=$(slurp)
        if [ -n "$GEOM" ]; then
            notify-send -a "Screen Recorder" -i "media-record" "Recording Started" "Selected Area (Super+Alt+R to stop)"
            wf-recorder -g "$GEOM" -f "$FILE_PATH" -c h264_vaapi -d /dev/dri/renderD128 2>/dev/null || wf-recorder -g "$GEOM" -f "$FILE_PATH" -c libx264 2>/dev/null &
        fi
        ;;
esac
