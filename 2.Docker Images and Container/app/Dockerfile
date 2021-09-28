FROM node

WORKDIR /app

COPY package.json /app

RUN npm install

# COPY (Host file system) (Container/images file system)
COPY . /app

#when container is running, this port will be exposed to out local machine
#Noted this is just for documentation PORT
EXPOSE 80

#RUN vs CMD
# CMD will not execute when still creating the images, instead will run when container being run.With no base image and no CMD we did get an error
CMD ["node", "server.js"]
