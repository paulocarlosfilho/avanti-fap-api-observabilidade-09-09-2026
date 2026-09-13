# ---------- Estagio 1: deps de producao (isoladas do build) ----------
FROM node:20-alpine AS deps

WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev

# ---------- Estagio 2: builder (compila o TypeScript) ----------
FROM node:20-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci

COPY tsconfig.json ./
COPY src ./src

RUN npm run build

# ---------- Estagio 3: runtime (alpine atualizado, sem gcr.io) ----------
FROM node:20-alpine AS runtime

WORKDIR /app
ENV NODE_ENV=production

# Atualiza os pacotes do sistema operacional para corrigir CVEs conhecidas da imagem base
RUN apk update && apk upgrade --no-cache

# Remove o npm/npx/corepack da imagem final: a aplicacao roda so com "node", nao precisa
# do npm em producao, e isso elimina as CVEs dos pacotes internos do proprio npm (tar, glob, etc)
RUN rm -rf /usr/local/lib/node_modules/npm \
    /usr/local/bin/npm \
    /usr/local/bin/npx \
    /usr/local/bin/corepack \
    /usr/local/lib/node_modules/corepack

COPY --from=deps /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

# Roda como usuario nao-root (a imagem alpine ja tem o usuario "node" criado)
USER node

EXPOSE 3000
CMD ["node", "dist/server.js"]