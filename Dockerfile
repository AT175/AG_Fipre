FROM node:20-alpine

WORKDIR /app

COPY paradise_ag_backend/package*.json ./
RUN npm ci

COPY paradise_ag_backend/ ./
RUN npm run build
RUN npm prune --omit=dev

EXPOSE 3000

CMD ["npm", "run", "start:prod"]
