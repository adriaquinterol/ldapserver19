#! /bin/bash
#

if [ -z "$DEBUG" ]; then
  DEBUG=0
fi
echo $DEBUG

function serviceStart(){
  if [ $DEBUG -eq 1 ]; then 
    echo "slapd starting..."
  fi
  /sbin/slapd -d0
}

function initConf(){
  if [ $DEBUG -eq 1 ]; then
    echo "initConf"	
  fi    
  cp /opt/docker/ldap.conf /etc/openldap/.
  ulimit -n 1024
}

function initdb(){
  if [ $DEBUG -eq 1 ]; then
    echo "initdb"     
  fi 
  rm -rf /etc/openldap/slapd.d/*
  rm -rf /var/lib/ldap/*
  cp /opt/docker/DB_CONFIG /var/lib/ldap/.
  slaptest -f /opt/docker/slapd.conf -F /etc/openldap/slapd.d
  #slapadd -F /etc/openldap/slapd.d -l /opt/docker/edt.org.ldif
  chown -R ldap.ldap /etc/openldap/slapd.d
  chown -R ldap.ldap /var/lib/ldap
  #cp /opt/docker/ldap.conf /etc/openldap/.
}

function initdbedt(){
  if [ $DEBUG -eq 1 ]; then
    echo "initdbedt"
  fi
  rm -rf /etc/openldap/slapd.d/*
  rm -rf /var/lib/ldap/*
  cp /opt/docker/DB_CONFIG /var/lib/ldap/.
  slaptest -f /opt/docker/slapd.conf -F /etc/openldap/slapd.d
  slapadd -F /etc/openldap/slapd.d -l /opt/docker/edt.org.ldif
  chown -R ldap.ldap /etc/openldap/slapd.d
  chown -R ldap.ldap /var/lib/ldap
  #cp /opt/docker/ldap.conf /etc/openldap/.
}

function listdn(){
  if [ $DEBUG -eq 1 ]; then
    echo "listdn"	 
  fi
  slapcat | grep dn
}

function freeCommand(){
  if [ $DEBUG -eq 1 ]; then
    echo "freeCommand $1"
  fi
  eval "$1"
}


if [ $DEBUG -eq 1 ]; then
  echo "inicialitzant..."
  echo '$0:' $0
  echo '$1:' $1
fi  

initConf
case "$1" in
  initdb)
      initdb
      serviceStart;;
  initdbedt)
      initdbedt
      serviceStart;;
  listdn)
      listdn;;
  start)
      serviceStart;;
  *)
      freeCommand "$*";;
esac

exit 0
