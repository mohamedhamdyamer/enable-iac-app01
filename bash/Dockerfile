FROM nginx:stable

COPY ./* /usr/share/nginx/html

HEALTHCHECK CMD curl --fail http://localhost:80 || exit 1
