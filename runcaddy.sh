#!/bin/bash

### BEGIN INIT INFO
# Provides:          caddy
# Required-Start:    $network $local_fs $remote_fs
# Required-Stop:     $network $local_fs $remote_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Description:       Start or stop the caddy
### END INIT INFO

NAME="caddy"
NAME_BIN="caddy"
FILE="/root/caddyserver/"
BIN="${FILE}/caddy"
CONFIG="/etc/Caddyfile"
LOG="/tmp/caddy.log"

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
RETVAL=0

check_running(){
	PID=$(ps -ef |grep "${NAME_BIN}" |grep -v "grep" |grep -v "init.d" |grep -v "service" |awk '{print $2}')
	if [[ ! -z ${PID} ]]; then
		#echo -e "${Info}caddy 正在运行！"
		return 0
	else
		#echo -e "${Error}caddy 没有运行！"
		return 1
	fi
}
do_start(){
	check_running
	if [[ $? -eq 0 ]]; then
		echo -e "${Info} $NAME (PID ${PID}) 正在运行..." && exit 0
	else
		cd ${FILE}
		echo -e "${Info} $NAME 启动中..."
		ulimit -n 51200
		./caddy -conf=$CONFIG -quiet=true >> $LOG 2>&1 &
		sleep 1s
		check_running
		if [[ $? -eq 0 ]]; then
			echo -e "${Info} $NAME 启动成功 !"
		else
			echo -e "${Error} $NAME 启动失败(请运行脚本查看日志错误输出) !"
		fi
	fi
}
do_stop(){
	check_running
	if [[ $? -eq 0 ]]; then
		kill -9 ${PID}
		RETVAL=$?
		if [[ $RETVAL -eq 0 ]]; then
			echo -e "${Info} $NAME 停止成功 !"
		else
			echo -e "${Error} $NAME 停止失败 !"
		fi
	else
		echo -e "${Info} $NAME 未运行"
		RETVAL=1
	fi
}
do_status(){
	check_running
	if [[ $? -eq 0 ]]; then
		#read_config
		#View_User
		echo -e "${Info} $NAME (PID ${PID}) 正在运行..."
	else
		echo -e "${Info} $NAME 未运行 !"
		RETVAL=1
	fi
}
do_restart(){
	do_stop
	sleep 2s
	do_start
}
case "$1" in
	start|stop|restart|status)
	do_$1
	;;
	*)
	echo "使用方法: $0 { start | stop | restart | status }"
	RETVAL=1
	;;
esac
exit $RETVAL