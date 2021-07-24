FROM node:10-alpine

WORKDIR /app

COPY . .

RUN npm config set registry http://registry.npm.taobao.org/ \
&& npm config set sass_binary_site https://npm.taobao.org/mirrors/node-sass/ \
&& npm install

CMD ["npm", "run", "server"]

EXPOSE 4000