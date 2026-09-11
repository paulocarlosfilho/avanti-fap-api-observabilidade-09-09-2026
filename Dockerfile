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

# ---------- Estagio 3: runtime (distroless, sem shell/pacotes extras) ----------
FROM gcr.io/distroless/nodejs20-debian12:nonroot AS runtime

WORKDIR /app
ENV NODE_ENV=production

COPY --from=deps /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

EXPOSE 3000
CMD ["dist/server.js"]