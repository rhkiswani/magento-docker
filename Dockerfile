FROM node:16.17.0-bullseye-slim

RUN apt-get update -y && apt-get install -y ca-certificates

WORKDIR /app

ADD package.json postcss.config.js tailwind.config.js yarn.lock ./

RUN npm install && yarn cache clean && yarn && yarn next telemetry disable

ADD . .

# create a dedicated user and group for the app
RUN addgroup --gid 1002 --system nodejs
RUN adduser --system pumpapp --uid 1002

# ensure the app user owns the app code
RUN chown -R pumpapp:nodejs /app

# use the dedicated user for running the app. see also the `defaultSecurityContext` properties
# in the Helm chart YML file which must also specify this user.
USER pumpapp

EXPOSE 3000

CMD ["yarn", "prod-start"]
