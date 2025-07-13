# Stage 1: Build the Angular app
FROM node:18.18.2 AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install --force
COPY . .
RUN npm run build -- --output-path=./dist/out && ls -la ./dist/out

# Stage 2: Serve the Angular app using nginx
FROM nginx:1.25.1-alpine as runtime
COPY --from=builder /app/dist/out /usr/share/nginx/html
COPY nginx-custom.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
