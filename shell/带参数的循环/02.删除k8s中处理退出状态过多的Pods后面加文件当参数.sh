#!/bin/bash
#description:useradd
#Author by WinJay <WinJayX@Gmail.com>.
#Date 11/8/2014


while read line
do
kubectl delete -n ingress-nginx pods  --force --grace-period=0 "$line"
done < $1