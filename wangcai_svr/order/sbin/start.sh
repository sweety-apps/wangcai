#!/bin/bash

cd `dirname $0`

/usr/local/bin/uwsgi --ini ../conf/order_uwsgi.conf

