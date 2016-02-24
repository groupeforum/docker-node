FROM alpine:3.3

MAINTAINER Florian Girardey <florian@girardey.net>

ENV NODE_VERSION v5.7.0
ENV NPM_VERSION 3
ENV NODE_ENV production

RUN apk add --update libgcc libstdc++ wget make gcc g++ python linux-headers paxctl binutils-gold \
	&& cd /tmp \    
	&& wget --no-check-certificate https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}.tar.gz \
	&& tar xzf node-${NODE_VERSION}.tar.gz \
	&& cd /tmp/node-${NODE_VERSION} \
	&& ./configure --prefix=/usr --without-snapshot \
	&& make -j $(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
	&& make install \
	&& paxctl -cm /usr/bin/node \
	&& wget --no-check-certificate -O - https://npmjs.org/install.sh | sh \
	&& npm install -g npm@${NPM_VERSION} nodemon \
	&& find /usr/lib/node_modules/npm -name test -o -name .bin -type d | xargs rm -rf \
	&& apk del wget make gcc g++ python linux-headers paxctl binutils-gold \
	&& rm -rf /tmp/* \
		/var/cache/apk/* \
		/root/.npm \
		/root/.node-gyp \
		/usr/lib/node_modules/npm/man \
		/usr/lib/node_modules/npm/doc \
		/usr/lib/node_modules/npm/html \
		/usr/share/man \
	&& apk search --update

WORKDIR /usr/src