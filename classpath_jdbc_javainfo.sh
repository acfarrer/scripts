#! /bin/sh
### Test to set CLASSPATH for use within SAS process
## For testing JDBC connections 
#export CLASSPATH=/sasfs/test/sas/94/controlserver/sashome/SASVersionedJarRepository/eclipse/plugins/sas.intrnet.javatools_904300.0.0.20150204190000_v940m3/sas.intrnet.javatools.jar
JAVA_HOME=/sasfs/test/sas/94/sasgsubclient/sashome/SASPrivateJavaRuntimeEnvironment/9.4/jre
export JAVA_HOME

LD_LIBRARY_PATH=$JAVA_HOME/lib/i386/server:$JAVA_HOME/lib/i386:/sasfs/test/sas/94/sasgsubclient/sashome/SASFoundation/9.4/sasexe:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH

if [  "/sasfs/test/sas/94/sasgsubclient/sashome/Secure/sasexe" != "" ] ; then
  LD_LIBRARY_PATH=/sasfs/test/sas/94/sasgsubclient/sashome/Secure/sasexe:$LD_LIBRARY_PATH
  export LD_LIBRARY_PATH
fi

# JREOPTIONS is used by SASGSUB to connect to Java. 
# Copied from /sasfs/test/sas/94/sasgsubclient/sasconfig/Lev1/Applications/SASGridManagerClientUtility/9.4/sasgsub.cfg
CWD=$PWD

cd ~/sascode
#/sasfs/test/sas/94/controlserver/sashome/SASFoundation/9.4/sas -config ~/sasconfig/sas_jdbc.cfg -work ~/saswork/ -initstmt 'proc javainfo ;run ;'
/sasfs/test/sas/94/controlserver/sashome/SASFoundation/9.4/sas -work ~/saswork/ -initstmt 'proc javainfo ;run ;' -jreoptions "(-Djava.class.path=/sasfs/test/sas/94/sasgsubclient/sashome/SASVersionedJarRepository/eclipse/plugins/sas.launcher.jar)"


exclude(){
/sasfs/test/sas/94/controlserver/sashome/SASFoundation/9.4/sas \
-JREOPTIONS "(-Djava.class.path=/sasfs/test/sas/94/sasgsubclient/sashome/SASVersionedJarRepository/eclipse/plugins/sas.launcher.jar
              -Djava.security.auth.login.config=/sasfs/test/sas/94/sasgsubclient/sashome/SASFoundation/9.4/misc/tkjava/sas.login.config
              -Djava.security.policy=/sasfs/test/sas/94/sasgsubclient/sashome/SASFoundation/9.4/misc/tkjava/sas.policy
              -Djava.system.class.loader=com.sas.app.AppClassLoader
              -DPFS_TEMPLATE=/sasfs/test/sas/94/sasgsubclient/sashome/SASFoundation/9.4/misc/tkjava/qrpfstpt.xml
              -Dsas.app.class.path=/sasfs/test/sas/94/sasgsubclient/sashome/SASVersionedJarRepository/eclipse/plugins/tkjava.jar
              -Dsas.ext.config=/sasfs/test/sas/94/sasgsubclient/sashome/SASFoundation/9.4/misc/tkjava/sas.java.ext.config
              -Dtkj.app.launch.config=/sasfs/test/sas/94/sasgsubclient/sashome/SASVersionedJarRepository/picklist
             )" \
#-config ~/sasconfig/sas_jdbc.cfg \
-work ~/saswork/ \
-initstmt 'proc javainfo ;run ;'
}
rc=$?
cd $CWD
