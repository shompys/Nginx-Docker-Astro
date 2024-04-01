FROM node:20.12.0-alpine3.19 as base
FROM base AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY ./package*.json .
RUN npm ci
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build
FROM base AS runner
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json .
EXPOSE 4321
ENTRYPOINT npm run preview

