# Stage 1 - Build
FROM node:24-alpine AS builder
WORKDIR /usr/app
COPY package.json yarn.lock* package-lock.json* ./
RUN yarn install --frozen-lockfile
COPY . .
RUN yarn build:prod

# Stage 2 - Production
FROM node:24-alpine
WORKDIR /usr/app
ENV NODE_ENV=production
COPY package.json yarn.lock* package-lock.json* ./
RUN yarn install --frozen-lockfile --production
COPY --from=builder /usr/app/dist ./dist
COPY --from=builder /usr/app/config ./config

EXPOSE 3000
CMD ["node", "dist/src/index.js"]