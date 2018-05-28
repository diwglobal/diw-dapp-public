# get nodejs
FROM node:8.11.2

# create app directory
WORKDIR /usr/src/app

# copy packages
COPY package*.json ./
COPY lerna.json ./
COPY ./packages ./packages

# install packages
RUN npm install -g lerna
RUN lerna bootstrap

# build web-client
# RUN lerna run --scope web-client build

# copy startscript
ADD ./dockerEntry.sh /root/dockerEntry.sh
RUN chmod +x /root/dockerEntry.sh

# expose the ports
EXPOSE 3000

ENTRYPOINT ["/root/dockerEntry.sh"]