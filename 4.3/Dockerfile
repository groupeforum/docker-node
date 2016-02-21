FROM alpine:3.3

MAINTAINER Florian Girardey <florian@girardey.net>

## Install Node.js required packages
RUN apk add --no-cache curl make gcc g++ binutils-gold python linux-headers paxctl libgcc libstdc++

ENV NODE_VERSION v4.3.1
ENV NODE_ENV production

# Install Node.js
RUN curl -sSL https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}.tar.gz | tar -xz \
	&& cd /node-${NODE_VERSION} \
	&& ./configure --prefix=/usr --without-snapshot \
	&& NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
	&& make -j${NPROC} \
	&& make install \
	&& paxctl -cm /usr/bin/node

# Install Nodemon for development
RUN npm install -g nodemon \
	&& npm cache clean

# Remove many things to lighten the image
RUN apk del curl make gcc g++ binutils-gold python linux-headers paxctl \
	&& rm -rf /node-${NODE_VERSION} /etc/ssl /usr/include \
		/usr/share/man /tmp/* /var/cache/apk/* /root/.npm /root/.node-gyp \
		/usr/lib/node_modules/npm/man /usr/lib/node_modules/npm/doc /usr/lib/node_modules/npm/html

WORKDIR /usr/src