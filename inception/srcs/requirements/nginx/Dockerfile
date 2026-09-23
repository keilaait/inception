FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl \
    && openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/keait-he.key \
        -out /etc/nginx/ssl/keait-he.crt \
        -subj "/C=FR/ST=IDF/L=Paris/O=42/CN=keait-he.42.fr"

COPY conf/nginx.conf /etc/nginx/sites-available/wordpress.conf

RUN rm -f /etc/nginx/sites-enabled/default \
    && ln -s /etc/nginx/sites-available/wordpress.conf /etc/nginx/sites-enabled/wordpress.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
