FROM node:24.11.1-alpine3.22 AS builder

WORKDIR /app

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./

RUN npm install --global pnpm@12.18.0 \
    && pnpm install --frozen-lockfile

COPY . .

RUN pnpm check \
    && pnpm build

FROM nginx:1.29.2-alpine AS runner

COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /app/dist /usr/share/nginx/html

RUN chown -R nginx:nginx /usr/share/nginx/html \
    && touch /tmp/nginx.pid \
    && chown nginx:nginx /tmp/nginx.pid

USER nginx

EXPOSE 8081

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --quiet --output-document=- http://127.0.0.1:8081/ >/dev/null || exit 1

CMD ["nginx", "-g", "daemon off;"]
