#!/bin/bash

DIR=html_$(date +"%Y%m%d-%H%M%S")
DIR=html
mkdir -p $DIR
cat /proc/cpuinfo > $DIR/cpuinfo
cat /proc/meminfo > $DIR/meminfo
cat /proc/version > $DIR/version
df -h > $DIR/diskinfo
ifconfig > $DIR/ifconfig
HOSTNAME=$(hostname)
lstopo $DIR/$HOSTNAME.png

FN=$DIR/index.html
echo "<table>" > $FN

echo "<tr><td>Hostname</td><td>" >> $FN
echo "<a href=\"$HOSTNAME.png\">" >> $FN
echo "<img src=\"$HOSTNAME.png\" width=200></img>" >> $FN
echo "</a></td></tr>" >> $FN

echo "<tr><td>Total memory</td><td>" >> $FN
echo "<a href=\"meminfo\">" >> $FN
head -n 1 html/meminfo | cut -d':' -f2 >>$FN
echo "</a></td></tr>" >> $FN

echo "<tr><td>CPUs</td><td>" >> $FN
echo "<a href=\"cpuinfo\">" >> $FN
P=$(grep "processor" html/cpuinfo | tail -n 1 | cut -d':' -f2)
echo $P + 1 | bc >> $FN
echo "</a></td></tr>" >> $FN

P=$(grep "model name" html/cpuinfo | tail -n 1 | cut -d':' -f2)  # for x86 systems
[[ $P -lt 2 ]] && P=$(grep "cpu" html/cpuinfo | tail -n 1 | cut -d':' -f2)  # Power
echo "<tr><td>CPU type</td><td>" >> $FN
echo "<a href=\"cpuinfo\">" >> $FN
echo $P >> $FN
echo "</a></td></tr>" >> $FN

echo "<tr><td colspan=\"2\">" >> $FN
echo "<a href=\"diskinfo\">" >> $FN
echo "</a></td></tr>" >> $FN

echo "<tr><td>Linux version</td><td>" >> $FN
echo "<a href=\"version\">" >> $FN
uname -v >> $FN
echo "</a></td></tr>" >> $FN

echo "<tr><td>Ethernet interfaces</td><td>" >> $FN
echo "<a href=\"ifconfig\">" >> $FN
ifconfig | grep "Link encap" | wc -l >> $FN
echo "</a></td></tr>" >> $FN

echo "</table>" >> $FN


