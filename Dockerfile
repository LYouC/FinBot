# 使用Node.js官方镜像作为构建环境
FROM node:18-alpine as build-stage
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN npm install -g pnpm && pnpm install
COPY . .
RUN pnpm run build

# 使用Nginx作为生产环境
FROM python:3.10-slim as production-stage
WORKDIR /app
COPY --from=build-stage /app/dist /app
RUN pip install fastapi uvicorn

EXPOSE 3307
CMD ["uvicorn", "script.main:app", "--host", "0.0.0.0", "--port", "3307"]
