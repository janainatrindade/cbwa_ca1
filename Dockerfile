# getting the alpine lastest version 
FROM alpine:latest AS builder

# Install all dependencies required for compiling busybox
RUN apk add gcc musl-dev make perl

# Download busybox sources
RUN wget https://busybox.net/downloads/busybox-1.35.0.tar.bz2 \
  && tar xf busybox-1.35.0.tar.bz2 \
  && mv /busybox-1.35.0 /busybox

WORKDIR /busybox

# Copy the busybox build config (limited to httpd)
COPY .config .

# Compile and install busybox
RUN make && make install

# Create  a  user  called  static  to  secure  running  commands  in  the  image  build  and  container 
runtime processes
RUN adduser -D static

# Switch to the scratch image
FROM scratch

#expose port 8080
EXPOSE 8080

# Copy over the user
COPY --from=builder /etc/passwd /etc/passwd

# Copy the busybox static binary
COPY --from=builder /busybox/_install/bin/busybox /

# Use our non-root user
USER static
WORKDIR /home/static

# Uploads a blank default httpd.conf
COPY httpd.conf .

#static website
RUN wget https://github.com/janainatrindade/webdev_labs/archive/refs/heads/main.zip \
  && unzip main.zip \
  && mv /main /home/static

# Run busybox httpd
CMD ["/busybox", "httpd", "-f", "-v", "-p", "8080", "-c", "httpd.conf"]
