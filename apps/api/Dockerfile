FROM node:24-alpine

WORKDIR /workspace/apps/api
COPY apps/api/package*.json ./
RUN npm ci

WORKDIR /workspace
COPY apps/api ./apps/api
COPY packages/shared ./packages/shared

WORKDIR /workspace/apps/api
RUN npm run prisma:generate && npm run build

EXPOSE 4000

CMD ["sh", "-lc", "npx prisma migrate deploy && node dist/apps/api/src/server.js"]
