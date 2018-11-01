#!/bin/sh
ver=$(/usr/sbin/geth-akroma version | grep "Version: " | grep "akroma" | sed "s/Version: //" |  sed "s/-akroma//")
printf "$ver"