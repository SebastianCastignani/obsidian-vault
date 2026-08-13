# Etapa 1: build
FROM node:22 AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y git

RUN git clone --depth 1 https://github.com/jackyzha0/quartz.git .

RUN npm ci

COPY content ./content
COPY quartz.config.ts ./quartz.config.ts

RUN npx quartz build

# Etapa 2: servir el sitio estático generado
FROM node:22

WORKDIR /app

COPY --from=builder /app/public ./public

RUN npm install -g serve

EXPOSE 8080

CMD ["serve", "public", "-l", "8080"]