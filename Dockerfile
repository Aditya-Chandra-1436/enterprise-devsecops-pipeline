# BUILD STAGE

FROM node:20-bookworm-slim AS builder

WORKDIR /app

COPY package*.json ./

RUN npm install --omit=dev

COPY . .

# PRODUCTION STAGE

FROM gcr.io/distroless/nodejs20-debian12

WORKDIR /app

COPY --from=builder /app /app

EXPOSE 3000

USER nonroot

CMD ["app.js"]
