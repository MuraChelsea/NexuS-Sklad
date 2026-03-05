FROM node:24-alpine AS build

WORKDIR /workspace/apps/web
COPY apps/web/package*.json ./
RUN npm ci

WORKDIR /workspace
COPY apps/web ./apps/web
COPY packages/shared ./packages/shared

WORKDIR /workspace/apps/web
ARG VITE_NEXUSSKLAD_API_BASE_URL=
ENV VITE_NEXUSSKLAD_API_BASE_URL=$VITE_NEXUSSKLAD_API_BASE_URL
RUN npm run build

FROM nginx:1.27-alpine

COPY apps/web/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /workspace/apps/web/dist /usr/share/nginx/html

EXPOSE 80
