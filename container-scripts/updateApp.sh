#!/bin/bash

#Loop determining state of WLS
function check_wls {
    action=$1
    host=$2
    admin_port=$3
    sleeptime=$4
    while true
    do
        sleep $sleeptime
        if [ "$action" == "started" ]; then
            started_url="http://$host:$admin_port/weblogic/ready"
            echo -e "[Provisioning Script] Waiting for WebLogic server to get $action, checking $started_url"
            status=`/usr/bin/curl -s -i $started_url | grep "200 OK"`
            echo "[Provisioning Script] Status:" $status
            if [ ! -z "$status" ]; then
              break
            fi
        elif [ "$action" == "shutdown" ]; then
            shutdown_url="http://$host:$admin_port"
            echo -e "[Provisioning Script] Waiting for WebLogic server to get $action, checking $shutdown_url"
            status=`/usr/bin/curl -s -i $shutdown_url | grep "500 Can't connect"`
            if [ ! -z "$status" ]; then
              break
            fi
        fi
    done
    echo -e "[Provisioning Script] WebLogic Server has $action"
}

echo 'WEBAPP_WARFILE: ' $WEBAPP_WARFILE
echo 'SCRIPT_HOME: ' $SCRIPT_HOME
echo 'ADMIN_USER: ' $ADMIN_USER
echo 'ADMIN_PASSWORD: ' $ADMIN_PASSWORD
echo 'APP_PKG_FILE: ' $APP_PKG_FILE

echo 'Changing current directory to ' $DOMAIN_HOME
cd $DOMAIN_HOME

echo 'Running Admin Server in background'
/u01/oracle/startAdminServer.sh &

echo 'Waiting for Admin Server to reach RUNNING state'
check_wls "started" localhost $ADMIN_PORT 2

echo 'Application update'
wlst.sh /u01/oracle/appdeploy.py
