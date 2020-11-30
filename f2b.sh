#!/bin/bash
# file: f2b.sh
# Source: $me
# Date: Nov 30 2020 at 17:18
# Description: zgrep fail2ban logs for any ban 2nd or 3rd octecs and compress older log

#Fail2ban Reporting
#
# Most problematic subnets - 3rd Octets
#
zgrep -h "Ban " /var/log/fail2ban.log* | awk '{print $NF}' | awk -F\. '{print $1"."$2"."$3"."}' | sort | uniq -c  | sort -n | tail > /var/log/fail2
ban/`date +\%d\%m\%Y\%H\%M\%S`-fail2ban_worse_3rd_Octet_subnets.log 2>&
#
sleep 10
# Most problematic subnets - 2nd Octets
#
zgrep -h "Ban " /var/log/fail2ban.log* | awk '{print $NF}' | awk -F\. '{print $1"."$2"."}' | sort | uniq -c  | sort -n | tail > /var/log/fail2ban/`date +\%d\%m\%Y\%H\%M\%S`-fail2ban_worse_2nd_Octet_subnets.log 2>&
#
sleep 10
# All offending Banned IPs
#
zgrep -h "Ban " /var/log/fail2ban.log* | awk '{print $NF}' | sort | uniq -c > /var/log/fail2ban/`date +\%d\%m\%Y\%H\%M\%S`-fail2ban_all_banned_IPs.log 2>&1
#
sleep 10
# Compress logs older than 3days
find /var/log/fail2ban/*.log -mtime +3 -print -exec gzip {} \;
