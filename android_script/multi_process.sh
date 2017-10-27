#!/system/bin/sh
while getopts "n:" arg
do
	case $arg in
	n)
		name=$OPTARG;;
		

	?)
		echo "Unkonw argument"
		exit 1
	
	esac
done

pid=`pidof $name`

function get_max() {
	local newarray
	newarray=(`echo "$@"`)

	max=0

	for arr in ${newarray[@]};do
		(($max<$arr)) && max=$arr
	done

	echo $max
}

if [[ ! -n $pid ]]; then
	echo "hello"
	strace -T  -s40960 -ff -tt -o /data/stracelog/$name.strace $name 
else
	echo "bye" 
	strace -T  -s40960 -ff -tt -o /data/stracelog/$name.strace -p `pidof $name | tr ' ' ','` 
fi


