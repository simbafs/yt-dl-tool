#!/bin/bash

ytdl=yt-dlp
ffmpeg=ffmpeg

# check $ytdl is installed
which $ytdl
if [[ $? != 0 ]];
then
	echo please install $ytdl first
	echo '```'
	echo sudo curl -L https://yt-dl.org/downloads/latest/$ytdl -o /usr/local/bin/youtube-dl
	echo sudo chmod a+rx /usr/local/bin/$ytdl
	echo '```'
	exit 1
fi

# check $ffmpeg is installed
which $ffmpeg
if [[ $? != 0 ]];
then
	echo please install $ffmpeg first
	echo '```'
	echo sudo apt install $ffmpeg
	echo '```'
	exit 2
fi

declare -A data

while read -r line
do
	url=$(echo $line | cut -d' ' -f1)
	fileName=$(echo $line | cut -d' ' -f2)
	data[${url}]=$fileName
done

for url in "${!data[@]}"
do
	# Escape comment
	[[ $url =~ ^#.* ]] && continue

	# Set a flag if name is empty
	if [[ $url == ${data[$url]} ]];
	then
		name=""
	else
		name=${data[$url]}
	fi

	# parse different format 
	[[ $url != https://* ]] && url=https://youtu.be/$url

	echo Download $name: $url

	if [[ -z $name ]];
	then
		$ytdl -q -x --audio-format mp3 $url 
	else
		$ytdl -q -o "${name}.%(ext)s" -x --audio-format mp3 $url
	fi
done
