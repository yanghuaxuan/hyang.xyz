mkdir -p /var/www/hugo_pub
cp -r ./public/* /var/www/hugo_pub
chown -R root:www-data /var/www/hugo_pub

cat <<EOF > /etc/nginx/nginx.conf
user nginx;

# Set number of worker processes automatically based on number of CPU cores.
worker_processes auto;

# Enables the use of JIT for regular expressions to speed-up their processing.
pcre_jit on;

# Configures default error logger.
error_log /var/log/nginx/error.log warn;

# Includes files with directives to load dynamic modules.
include /etc/nginx/modules/*.conf;

# Include files with config snippets into the root context.
include /etc/nginx/conf.d/*.conf;

events {
	# The maximum number of simultaneous connections that can be opened by
	# a worker process.
	worker_connections 1024;
}

http {
	# Includes mapping of file name extensions to MIME types of responses
	# and defines the default type.
	include /etc/nginx/mime.types;
	default_type application/octet-stream;

	# Name servers used to resolve names of upstream servers into addresses.
	# It's also needed when using tcpsocket and udpsocket in Lua modules.
	#resolver 1.1.1.1 1.0.0.1 2606:4700:4700::1111 2606:4700:4700::1001;

	# Don't tell nginx version to the clients. Default is 'on'.
	server_tokens off;

	# Specifies the maximum accepted body size of a client request, as
	# indicated by the request header Content-Length. If the stated content
	# length is greater than this size, then the client receives the HTTP
	# error code 413. Set to 0 to disable. Default is '1m'.
	client_max_body_size 1m;

	# Sendfile copies data between one FD and other from within the kernel,
	# which is more efficient than read() + write(). Default is off.
	sendfile on;

	# Causes nginx to attempt to send its HTTP response head in one packet,
	# instead of using partial frames. Default is 'off'.
	tcp_nopush on;

	# Enable gzipping of responses.
	gzip on;

	# Set the Vary HTTP header as defined in the RFC 2616. Default is 'off'.
	gzip_vary on;

	# Specifies the main log format.
	log_format main '$remote_addr - $remote_user [$time_local] "$request" '
			'$status $body_bytes_sent "$http_referer" '
			'"$http_user_agent" "$http_x_forwarded_for"';

	# Sets the path, format, and configuration for a buffered log write.
	access_log /var/log/nginx/access.log main;


	# Includes virtual hosts configs.
	include /etc/nginx/http.d/*.conf;
}
EOF

cat <<EOF > /etc/nginx/http.d/hugo.conf
server {
    # Listen on port 80 for HTTP requests
    listen 8080;

    # Root directory for serving web content for this virtual host
    root /var/www/hugo_pub;

    # Default index file for this virtual host
    index index.html index.htm;

    location ~* \.(?:jpg|jpeg|gif|png|ico|svg|webp)$ {
      expires 1M;
      access_log off;
      # max-age must be in seconds
      add_header Cache-Control "max-age=2629746, public";
    }

    location ~* \.(?:css|js)$ {
      expires 1y;
      access_log off;
      add_header Cache-Control "max-age=31556952, public";
    }

    gzip on;
    gzip_min_length 1100;
    gzip_buffers 4 32k;
    gzip_types text/plain application/x-javascript text/xml text/css;
    gzip_vary on;

    # Logging configuration
    access_log /var/log/nginx/hugo_pub_access.log;
    error_log /var/log/nginx/hugo_pub_error.log;
}
EOF

