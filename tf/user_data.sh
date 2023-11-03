#!/bin/bash

export HOME=/home/ec2-user
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash

. ~/.nvm/nvm.sh
nvm install --lts

curl -L -o repo.zip https://github.com/nodejs/examples/archive/refs/heads/main.zip
unzip repo.zip
cd examples-main/servers/express/api-with-express-and-handlebars

npm install

npm start
