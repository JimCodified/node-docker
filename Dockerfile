FROM node:12.18.1

RUN apt-get update &&\
    apt-get install -y git vim &&\
    rm -rf /var/lib/apt/lists/*
 
WORKDIR /code
 
COPY *.json .
 
RUN npm install
 
COPY . .
 
CMD [ "node", "server.js" ]
