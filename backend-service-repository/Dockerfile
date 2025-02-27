# Stage 1: Build stage
FROM node:slim AS build

# Create app directory
RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

# Install app dependencies
COPY /src/package.json /usr/src/app/
RUN npm install

# Bundle app source
COPY ./src/ /usr/src/app/

# Stage 2: Runtime stage
FROM node:slim

# Create app directory
RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

# Copy only necessary files from build stagg
COPY --from=build /usr/src/app /usr/src/app

EXPOSE 80

CMD ["npm", "start"]
