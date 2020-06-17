FROM node:12 as base

EXPOSE 3000
WORKDIR /app
COPY package.json /app/
RUN npm install

ARG NODE_ENV=production
ARG API_URL=http://localhost:8000/
ENV API_URL=$API_URL
COPY . .
RUN npm run build

FROM nginx:1.17
EXPOSE 80
WORKDIR /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY bin/nginx.conf /etc/nginx/nginx.conf
COPY --from=base /app/build /usr/share/nginx/html
COPY ./env.sh .
COPY ./docker.env .
RUN chmod +x env.sh
CMD ["/bin/bash", "-c", "/usr/share/nginx/html/env.sh && nginx"]
