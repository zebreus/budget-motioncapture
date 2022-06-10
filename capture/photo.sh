#!/bin/bash



usage="$(basename "$0") [h] [-i file] [-v n] [-h n] [-f n] [-b n] [-t n] -- program to take videos from remote raspberrypi

where:
    -i  set file with raspberry pi ips
    -v  set the vertical resolution (default: 720)
    -h  set the horizontal resolution (default: 1280)
    -f  set the framerate (default: 30)
    -b  set the bitrate (default: 20000000)
    -t  set the length in millisecond (default: 10000)"

filename="lukasips"
vertical=720
horizontal=1280
fps=30
bitrate=200000000
timeout=10000

while getopts ':hs:' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    i) filename=$OPTARG
       ;;
    v) vertical=$OPTARG
       ;;
    h) horizontal=$OPTARG
       ;;
    f) fps=$OPTARG
       ;;
    b) bitrate=$OPTARG
       ;;
    t) timeout=$OPTARG
       ;;
    :) printf "missing argument for -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
done

shift $((OPTIND - 1))

for line in $(cat $filename)
do
    name="$line"
    echo Taking video on $name
    ssh pi@$name "date +%s%3N > timeref.txt && raspivid -vf -o out.h264 -w $horizontal -h $vertical -t $timeout -fps $fps -b $bitrate -pf high" &
done

echo waiting
sleep 15s
echo continue

for line in $(cat $filename)
do
    name="$line"
    echo Copying video from $name
    scp pi@$name:out.h264 out_$name.h264
done

> info

camid=0;
for line in $(cat $filename)
do
	echo Processing video from $name
    name="$line"
    scp pi@$name:timeref.txt timeref.txt
    timeref='cat timeref.txt'
    echo "$camid $name $timeref" >> info
    rm timeref.txt
    mkdir camera_$camid
    ffmpeg -i out_$name.h264 camera_$camid/out_%03d.bmp
    rm out_"$name".h264
    ssh pi@$name 'rm timeref.txt && rm out.h264' &
    echo $camid
    let "camid++"
    
done
