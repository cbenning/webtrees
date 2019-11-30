#!/bin/bash
#A2HTTPSPORT=${PORT:-443}
A2HTTPPORT=${PORT:-80}
echo "Listen *:$A2HTTPPORT" > /etc/apache2/ports.conf
