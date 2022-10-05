FROM alpine:3.15

# installs required packages
RUN apk upgrade
RUN apk add openssl nginx openrc

# create certificates
RUN openssl genrsa -des3 -passout pass:x -out server.pass.key 2048
RUN openssl rsa -passin pass:x -in server.pass.key -out server.key
RUN rm server.pass.key
RUN openssl req -new -key server.key -out server.csr -subj "/C=UK/ST=Warwickshire/L=Leamington/O=OrgName/OU=IT Department/CN=example.com"
RUN openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
RUN mkdir /etc/nginx/cert/
RUN mv server.crt /etc/nginx/cert/.
RUN mv server.key /etc/nginx/cert/.

# enables config files in /etc/nginx/conf.d
RUN sed -i '/#include \/etc\/nginx\/conf.d/s/^#//g' /etc/nginx/nginx.conf

# starts nginx
CMD ["nginx", "-g", "daemon off;"]