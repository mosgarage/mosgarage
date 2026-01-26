# Use a lightweight base image
FROM alpine:3.18

# Install dependencies (Nginx, zip, curl)
RUN apk add --no-cache nginx zip curl && \
    mkdir -p /var/www/html

# Download and extract 2048 game files
RUN curl -o /var/www/html/master.zip -L https://codeload.github.com/gabrielecirulli/2048/zip/master && \
    cd /var/www/html/ && unzip master.zip && mv 2048-master/* . && rm -rf 2048-master master.zip

# Copy Nginx configuration file
COPY default.conf /etc/nginx/http.d/default.conf

# Expose port 80 for Nginx
EXPOSE 80

# Start Nginx in foreground
CMD ["nginx", "-g", "daemon off;"]