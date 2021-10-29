FROM node:10-alpine as build
WORKDIR /app
COPY ./public /app/public
FROM nginx
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/public /usr/share/nginx/html