#!/bin/bash

function usage {
  echo "Usage: [sudo] $(basename $0) [no|yes|add|remove]"
}

function set_procrast_no() {
  sed -e 's/^#\(.*# procrast\)/\1/g' /etc/hosts > /etc/hosts.new
  mv /etc/hosts.new /etc/hosts
}

function set_procrast_yes() {
  sed -e 's/\(^[^\#]*# procrast\)/#\1/g' /etc/hosts > /etc/hosts.new
  mv /etc/hosts.new /etc/hosts
}

function add_host() {
  echo "127.0.0.1 $1 # procrast" >> /etc/hosts
}

function remove_host() {
  sed "s/.*$1 # procrast//g" /etc/hosts > /etc/hosts.new
  mv /etc/hosts.new /etc/hosts
}

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
  sudo $0 $*
  exit
fi

COMMAND=$1
shift

case $COMMAND in
'no')
  set_procrast_no
  ;;
'yes')
  set_procrast_yes
  ;;
'add')
  add_host $*
  ;;
'remove')
  remove_host $*
  ;;
*)
  usage
  exit 1
  ;;
esac

