#/bin/bash 

envsubst \$ASPACE_STAFF,\$ASPACE_PUBLIC < /etc/nginx/conf.d/aspace.template  > /etc/nginx/conf.d/default.conf
nginx -g 'daemon off;'
