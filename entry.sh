
mkdir -p /var/cache/nginx/client_temp
mkdir -p /var/log/nginx
mkdir -p /var/run
touch /var/run/nginx.pid
nginx -g 'daemon off;'

