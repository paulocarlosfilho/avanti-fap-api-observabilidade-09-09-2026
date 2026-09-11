# ---------- Estagio 1: builder ----------
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY tsconfig.json ./
COPY src ./src

RUN npm run build

# ---------- Estagio 2: runtime (imagem final, enxuta) ----------
FROM node:20-alpine AS runtime

WORKDIR /app
ENV NODE_ENV=production

COPY package*.json ./
RUN npm ci --omit=dev

COPY --from=builder /app/dist ./dist

# Roda como usuario nao-root (boa pratica de seguranca)
USER node

EXPOSE 3000
CMD ["node", "dist/server.js"]