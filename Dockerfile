# BUILD STAGE

FROM node:20-bookworm-slim AS builder

RUN apt-get update && \
    apt-get upgrade -y && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package*.json ./

RUN npm ci --omit=dev

COPY . .

# PRODUCTION STAGE

FROM node:20-bookworm-slim

RUN apt-get update && \
    apt-get upgrade -y && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /app /app

EXPOSE 3000

USER node

CMD ["node", "app.js"]
