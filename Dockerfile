FROM nginx:1.27-alpine

ARG VERSION=dev
ARG BUILD_TIME=unknown

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY public/ /usr/share/nginx/html/

RUN sed -i "s|__VERSION__|${VERSION}|g; s|__BUILD_TIME__|${BUILD_TIME}|g" /usr/share/nginx/html/index.html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://127.0.0.1/health || exit 1
