
mkdir -p /var/cache/nginx/client_temp
mkdir -p /var/log/nginx
touch /var/run/nginx.pid
nginx -g 'daemon off;'

