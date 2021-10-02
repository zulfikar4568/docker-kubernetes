FROM node:14

ARG DEFAULT_PORT=80

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

ENV PORT $DEFAULT_PORT

EXPOSE $PORT

# This is Anonymous Volumes Managae by Docker
# VOLUME [ "inside container", ]
# VOLUME [ "/app/feedback" ]

CMD [ "node", "server.js" ]
# CMD [ "npm", "start" ]