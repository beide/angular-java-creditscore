import java.lang
import os
import string

adminport = os.environ.get('ADMIN_PORT', '7001')
username = os.environ.get('ADMIN_USER', 'user')
password = os.environ.get('ADMIN_PASSWORD', 'password')
appname  = os.environ.get('APP_NAME', 'creditscoreapp')
apppkg   = os.environ.get('APP_PKG_FILE', 'warfile')
targetcluster   = os.environ.get('CLUSTER_NAME', 'cluster-1')

print('admin_user  : [%s]' % username);
print('admin_password  : [%s]' % password);
print('appname  : [%s]' % appname);
print('apppkg  : [%s]' % apppkg);
print('targetcluster  : [%s]' % targetcluster);

connect( username, password, 't3://localhost:7001')

print 'stopping and undeploying ....'

stopApplication(appname)

undeploy(appname)

print 'deploying....'

deploy(appname, apppkg, targets=targetcluster) # , stageMode='stage'

startApplication(appname)

print 'disconnecting from admin server....'

disconnect()

exit()
