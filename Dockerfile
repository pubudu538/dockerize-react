FROM node:16-alpine3.17 as builder
# Set the working directory to /app inside the container
WORKDIR /app
# Copy app files
COPY . .
# Install dependencies (npm ci makes sure the exact versions in the lockfile gets installed)
RUN npm ci 
# Build the app
RUN npm run build

# Bundle static assets with nginx
FROM nginx:stable-alpine3.17 as production
ENV NODE_ENV production
# Copy built assets from `builder` image
COPY --from=builder /app/build /usr/share/nginx/html
# Add your nginx.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY --chown=10005:10005 entry.sh /etc/nginx/entry.sh

RUN chown -R 10005:10005 /usr/share/nginx && chmod -R 755 /usr/share/nginx /etc/nginx/ && \
        chown -R 10005:10005 /var/cache/nginx && \
        chown -R 10005:10005 /var/log/nginx && \
        chown -R 10005:10005 /etc/nginx/conf.d && \
        chown -R 10005:10005 /etc/nginx/entry.sh

RUN touch /var/run/nginx.pid && \
        chown -R 10005:10005 /var/run/nginx.pid

USER 10005

# Expose port
EXPOSE 80
# Start nginx


CMD /etc/nginx/entry.sh
# CMD ["nginx", "-g", "daemon off;"]