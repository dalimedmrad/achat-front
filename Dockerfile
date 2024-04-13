# Stage 1: Build the Angular app
FROM node:16.20.1 AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build -- --output-path=./dist/out

# Stage 2: Serve the Angular app using nginx
FROM nginx:1.25.1-alpine as runtime
COPY --from=build /app/dist/out /usr/share/nginx/html
COPY nginx-custom.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
