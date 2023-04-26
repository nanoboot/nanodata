# place in /bin directory of Tomcat installation

NANODATA_CONFPATH="{path to confpath directory}"

export JAVA_OPTS="$JAVA_OPTS -Dnanodata.confpath=${NANODATA_CONFPATH} -Dnanodata.allcanupdate=false"

