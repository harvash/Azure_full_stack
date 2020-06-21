FROM node:current-slim

WORKDIR /usr/src/app
COPY ./bulletin-board/package.json .
RUN npm install

EXPOSE 8081
CMD [ "npm", "start" ]

COPY ./bulletin-board .