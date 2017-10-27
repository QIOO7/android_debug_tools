#!/system/bin/sh

function get_max() {
	local newarray
	newarray=(`echo "$@"`)

	max=0

	for arr in ${newarray[@]};do
		(($max<$arr)) && max=$arr
	done

	echo $max
}

rm /system/bin/find
ln -s /system/xbin/busybox /system/bin/find
name=/data/strace/strace
proc_dir=$(find /data/strace  -regex ".*/strace/strace[0-9]*" | tr "/data/strace/$name" " ")

OLD_IFS="$IFS"
IFS=" "
arr=($proc_dir)
IFS="$OLD_IFS"

#echo ${#arr[@]}

get_max ${arr[@]}
#echo ${arr[@]}
#echo $max
