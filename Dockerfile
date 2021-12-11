FROM node:10-alpine as build
WORKDIR /app
COPY ./public /app/public
COPY ./google5bedcd4170c798b7.html /app/public/google5bedcd4170c798b7.html
FROM nginx
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/public /usr/share/nginx/html