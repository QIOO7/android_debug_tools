#!/system/bin/sh

trap ':' INT QUIT TERM PIPE HUP	# sends execution to end tracing section

while getopts "n:e:f" arg
do
	case $arg in
	n)
		name=$OPTARG;;

	e)
		event=$OPTARG;;

	f)
		write2file=0;;

	?)
		echo "Unkonw argument"
		exit 1
	esac
done


#just for learning how to using awk
#awk '{count++; print $0;} END {print "user count is", count}' /etc/passwd
#cat /data/stracelog/ls.strace | awk '$0 ~ /open|openat/ {print $NF} '
#cat /data/stracelog/ls.strace | awk '$1 ~ /[0-9]+/ {sub(/\(/, "", $2);print}'
#ls -lh | awk 'NR!=1 {sub(/[A-Z]+/, "", $5); print}'
#ls -l | awk '{gsub(/[0-9]+/, "", $0);print $0}'

strace  -o /data/stracelog/$name.strace  $name&

function warn {
	if ! eval "$@"; then
		echo >&2 "WARNING: command failed \"$@\""
	fi
}

function end {
	echo "Ending tracing..." 2>/dev/null
}

function parse_log {
	awk \
		'
		{print $0}
		$1 ~ /^open\(/ {
			file[$NF]=$1; 
			gsub(/open\(/, "", file[$NF]);
			gsub(/,/, "", file[$NF]);
			print $0 
		} 

		$1 ~ /^openat\(/ {
			file[$NF] = $2;
			gsub(/,/, "", file[$NF]);
			print $0
		}

		$1 ~ /^read\(|write\(|ioctl\(|close\(/ {
			fd=$1;
			gsub(/read\(|write\(|close\(|ioctl\(/, "", fd);
			gsub(/\,/, "", fd);
			gsub(/\)/, "", fd);
			if (fd > 2)
				gsub(/[0-9]+/, file[fd], $1); 
			print $0
		} 
		'
}

function parse_file {
	if [ -f /data/stracelog/$name.strace ];then
		tail -F /data/stracelog/$name.strace | 	parse_log
	fi&
}

if [[ $write2file = 0 ]]
then
	echo nicai
else
	parse_file
fi

wait

end

