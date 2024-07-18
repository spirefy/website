# Stage 1: Build the Hugo site
FROM klakegg/hugo:ext-alpine AS builder

# Install entr for watching changes
RUN apk add --no-cache entr

# Copy the local content into the container
COPY . /src

# Set the working directory
WORKDIR /src

# Copy the watch script into the container
#COPY watch-and-rebuild.sh /src/watch-and-rebuild.sh
#RUN chmod +x /src/watch-and-rebuild.sh

# Verify Hugo installation
RUN hugo version

# List contents of the source directory for debugging
RUN ls -la /src

# Build the Hugo site
RUN hugo --destination /output --verbose

# Stage 2: Serve the site with Nginx
FROM nginx:alpine

# Copy the built site from the previous stage
COPY --from=builder /output /usr/share/nginx/html
#COPY --from=builder /src/watch-and-rebuild.sh /src/watch-and-rebuild.sh

# Expose port 80
EXPOSE 80

# Start Nginx and the file watcher
# CMD ["sh", "-c", "nginx -g 'daemon off;' & /src/watch-and-rebuild.sh"]
CMD ["sh", "-c", "nginx -g 'daemon off;'"]

