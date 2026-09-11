# Stage 1: Build
FROM node:18-alpine AS builder
WORKDIR /usr/src/app
COPY package*.json ./
# Instala todas as dependências (incluindo devDependencies para ter os tipos do Jest no build)
RUN npm install --legacy-peer-deps
COPY tsconfig.json ./
COPY src/ ./src
RUN npm run build

# Stage 2: Produção (Mantém apenas o essencial limpo para rodar)
FROM node:18-alpine
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --production --legacy-peer-deps
COPY --from=builder /usr/src/app/dist ./dist

EXPOSE 3333
CMD ["node", "dist/server.js"]