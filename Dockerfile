FROM node:10-alpine as build

WORKDIR /app

COPY ./package.json /app/package.json

RUN npm config set registry http://registry.npm.taobao.org/ \
&& npm config set sass_binary_site https://npm.taobao.org/mirrors/node-sass/ \
&& npm install

COPY . .

RUN npm run build

FROM nginx
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/public /usr/share/nginx/html