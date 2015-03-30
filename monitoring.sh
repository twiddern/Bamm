# vim:tabstop=2:shiftwidth=2:expandtab
#!/bin/bash

# XMPP Setup
XMPP=$(which sendxmpp)
LOGIN=$(cat ${PWD}/xmpp.conf |\
			awk 'NF && $1!~/^#/ {gsub(/@/, " "); print " -u "$1,"-j "$2, "-p "$3, $4"@"$5}')

while true; do
	# Read host.conf
	while IFS= read HOSTS; do

		# Logs
		DATE=$(date +"%y-%m-%d")
		TIME=$(date +"%H:%M:%S")

		# Remove code comments
		[[ "$HOSTS" =~ ^"#".*$ ]] || [[ "$HOSTS" = "" ]] && continue
		HOST=$(echo $HOSTS | awk -F: ' {print $1}')
		PORT=$(echo $HOSTS | awk -F: '{print $2}')
		IP=$(getent ahostsv6 $HOST | awk 'NR==1{print $1}')
			# If no IPv6 available, then we use IPv4
			if [[ "$IP" =~ ^::ffff.*$ ]]; then
				IP=$(getent ahostsv4 $HOST | awk 'NR==1{print $1}')
				PROTO="4"
			else
				PROTO="6"
			fi

		# Check if host and port is alive
		CHECK=$(timeout 1 \
					bash -c '>/dev/tcp/'"$IP"'/'"$PORT"'' 2>/dev/null && echo ok || echo nok)

		if [ $CHECK == ok ]; then
			echo -e "[$TIME] \033[0;32m$CHECK:\033[0m\t$HOST\t$PORT"
		else
			echo -e "[$TIME] \033[1;31m$CHECK:\t$HOST\t$PORT\033[0m"
		fi

		# Traceroute and sending message
		case "$CHECK" in
			nok)	# Send XMPP notice
						echo "[$TIME] Warning: Port $PORT on $HOST is not reachable!" \
						> ${PWD}/log/"$DATE"-"$HOST".log.swp
						$XMPP -t -m ${PWD}/log/"$DATE"-"$HOST".log.swp $LOGIN

						# Logging
						traceroute -"$PROTO"nm 20 $HOST >> ${PWD}/log/"$DATE"-"$HOST".log.swp
						cat ${PWD}/log/"$DATE"-"$HOST".log.swp >> ${PWD}/log/"$DATE"-"$HOST".log
						rm ${PWD}/log/"$DATE"-"$HOST".log.swp
			;;
		esac
	done < ${PWD}/hosts.conf

# wait 5 minutes..
sleep 300

done
