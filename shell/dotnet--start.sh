#!/bin/bash
cd /usr/share/nginx/html/activityweek
dotnet /usr/share/nginx/html/activityweek/Nerc.ActivityWeek.FrontEnd.dll --urls "http://0.0.0.0:80"
