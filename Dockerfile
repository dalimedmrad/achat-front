# Étape 1 : build
FROM node:14 AS builder
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install -g @angular/cli@12.0.5 && npm install

COPY . .
RUN ng build

# Étape 2 : image nginx
FROM nginx:1.25.1-alpine AS runtime
COPY --from=builder /app/dist/crudtuto-front /usr/share/nginx/html
COPY nginx-custom.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
