#!/bin/sh
case $1/$2 in
  post/*)
	  systemctl restart iwd.service
    ;;
esac
