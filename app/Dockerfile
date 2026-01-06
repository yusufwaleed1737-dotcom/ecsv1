FROM node:20-alpine AS builder

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install

COPY . .


RUN yarn build
FROM nginx:stable-alpine
COPY --from=builder /app/build /usr/share/nginx/html
RUN echo '{"status": "ok"}' > /usr/share/nginx/html/health.json

EXPOSE 80 

CMD ["nginx", "-g", "daemon off;"]