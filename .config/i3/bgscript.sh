NUM_PICS=156
INTERVAL=0.05
PIC_DIR="$HOME/.wallpaper/archbg"
PIC_NAME="bg_"
FILETYPE="png"

while true; do
    i="1"
    while [ $i -le $NUM_PICS ]
    do
        feh --bg-center --bg-scale $PIC_DIR/$PIC_NAME$i.$FILETYPE
        i=$[$i+1]
        sleep $INTERVAL
    done
done
