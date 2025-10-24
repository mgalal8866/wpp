FROM node:22.20.0-alpine AS base
WORKDIR /usr/src/wpp-server
ENV NODE_ENV=production PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
COPY package.json ./

# تثبيت المكتبات الضرورية لبناء sharp من المصدر
RUN apk update && \
    apk add --no-cache \
    vips-dev \
    fftw-dev \
    gcc \
    g++ \
    make \
    libc6-compat \
    python3 \
    py3-pip \
    build-base \
    cairo-dev \
    jpeg-dev \
    pango-dev \
    giflib-dev \
    pixman-dev \
    && rm -rf /var/cache/apk/*

COPY install-dependencies.sh ./install-dependencies.sh
RUN sh ./install-dependencies.sh

# تثبيت الحزم مع بناء sharp من المصدر
RUN yarn install --production --pure-lockfile && \
    yarn add sharp --build-from-source --ignore-engines && \
    yarn cache clean

FROM base AS build
WORKDIR /usr/src/wpp-server
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
COPY package.json  ./
RUN yarn install --production=false --pure-lockfile
RUN yarn cache clean
COPY . .
RUN yarn build

FROM node:22.20.0-alpine
WORKDIR /usr/src/wpp-server/

# تثبيت المكتبات المطلوبة للتشغيل
RUN apk add --no-cache \
    chromium \
    vips \
    fftw \
    libc6-compat \
    && rm -rf /var/cache/apk/*

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    NODE_ENV=production

# نسخ node_modules من مرحلة base (تحتوي على sharp المبني)
COPY --from=base /usr/src/wpp-server/node_modules ./node_modules
COPY --from=build /usr/src/wpp-server/dist ./dist
COPY package.json ./

EXPOSE 21465
ENTRYPOINT ["node", "dist/server.js"]
