FROM node:20-alpine As development
WORKDIR /usr/src/app
ADD package*.json ./
RUN npm install
ADD . .
RUN npm run build

FROM node:20-alpine as production
WORKDIR /usr/src/app
ADD package*.json ./
COPY --from=development /usr/src/app/node_modules/ ./node_modules/
RUN npm install
RUN npm install dd-trace --save
COPY --from=development /usr/src/app/dist ./dist

EXPOSE 3000
CMD ["node", "--require", "dd-trace/init", "/usr/src/app/dist/main.js"]
