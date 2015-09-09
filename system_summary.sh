#!/bin/bash

HOSTNAME=$(hostname -s)
DIR=$HOSTNAME
mkdir -p $DIR
lstopo --of png $DIR/$HOSTNAME.png
cat /proc/cpuinfo > $DIR/cpuinfo
lscpu > $DIR/lscpu
cat /proc/meminfo > $DIR/meminfo
cat /proc/version > $DIR/version
lsb_release -a > $DIR/os
[ $? -ne 0 ] && cat /etc/redhat-release > $DIR/os
lsblk > $DIR/lsblk
df -h > $DIR/diskinfo
ifconfig > $DIR/ifconfig
[ $? -ne 0 ] && ip link > $DIR/ifconfig
lspci > $DIR/lspci

FN=$HOSTNAME.html
echo Writing html to $FN and subdirectory $DIR

echo "<table>" > $FN

echo "<tr>" >> $FN
echo "<th colspan=\"2\">System summary for $HOSTNAME</th>" >> $FN
echo "</tr>" >> $FN

echo "<tr>" >> $FN
echo "<td>lstopo image</td>" >> $FN
echo "<td><a href=\"$DIR/$HOSTNAME.png\">" >> $FN
echo "<img src=\"$DIR/$HOSTNAME.png\" width=200></img>" >> $FN
echo "</a></td>" >> $FN
echo "</tr>" >> $FN

echo "<tr>" >> $FN
echo "<td>CPUs</td>" >> $FN
echo "<td><a href=\"$DIR/cpuinfo\">" >> $FN
P=$(grep "processor" $DIR/cpuinfo | tail -n 1 | cut -d':' -f2)
echo $P + 1 | bc >> $FN
echo "</a></td>" >> $FN
echo "</tr>" >> $FN

echo "<tr>" >> $FN
echo "<tr><td colspan=\"2\">" >> $FN
echo "<a href=\"$DIR/lscpu\">lscpu" >> $FN
echo "</a></td>" >> $FN
echo "</tr>" >> $FN

echo "<tr>" >> $FN
P=$(grep "model name" $DIR/cpuinfo | tail -n 1 | cut -d':' -f2)  # for x86 systems
NP=$(grep "model name" $DIR/cpuinfo | wc -l)
[[ $NP -lt 1 ]] && P=$(grep "cpu" $DIR/cpuinfo | tail -n 1 | cut -d':' -f2)  # Power
echo "<td>CPU type</td>" >> $FN
echo "<td><a href=\"$DIR/cpuinfo\">" >> $FN
echo $P >> $FN
echo "</a></td>" >> $FN
echo "</tr>" >> $FN

echo "<tr>" >> $FN
echo "<td>Total memory</td>" >> $FN
echo "<td><a href=\"$DIR/meminfo\">" >> $FN
head -n 1 $DIR/meminfo | cut -d':' -f2 >>$FN
echo "</a></td>" >> $FN
echo "</tr>" >> $FN

echo "<tr>" >> $FN
echo "<td>Linux version</td>" >> $FN
echo "<td><a href=\"$DIR/version\">" >> $FN
uname -r >> $FN
echo "</a></td>" >> $FN
echo "</tr>" >> $FN

echo "<tr>" >> $FN
echo "<td>Operating system</td>" >> $FN
echo "<td><a href=\"$DIR/os\">" >> $FN
cat $DIR/os | grep "Description" | cut -d":" -f 2 >> $FN
echo "</a></td>" >> $FN
echo "</tr>" >> $FN

echo "<tr>" >> $FN
echo "<tr><td colspan=\"2\">" >> $FN
echo "<a href=\"$DIR/lspci\">lspci" >> $FN
echo "</a></td>" >> $FN
echo "</tr>" >> $FN

echo "<tr>" >> $FN
echo "<tr><td colspan=\"2\">" >> $FN
echo "<a href=\"$DIR/lsblk\">lsblk" >> $FN
echo "</a></td>" >> $FN
echo "</tr>" >> $FN

echo "<tr>" >> $FN
echo "<tr><td colspan=\"2\">" >> $FN
echo "<a href=\"$DIR/diskinfo\">Disk usage" >> $FN
echo "</a></td>" >> $FN
echo "</tr>" >> $FN

echo "<tr>" >> $FN
echo "<td>Ethernet interfaces</td>" >> $FN
echo "<td><a href=\"$DIR/ifconfig\">" >> $FN
ifconfig | grep "Link encap" | wc -l >> $FN
echo "</a></td>" >> $FN
echo "</tr>" >> $FN

echo "</table>" >> $FN

echo "<br>This page automatically generated using <a href="https://github.com/jschaub30/system_summary">this</a> script." >> $FN
