# MeteorJS App on Docker
FROM jadsonlourenco/docker-meteor-base

# Add your MeteorJS app and build the "bundle app" (NodeJS app)
COPY app/ /home/app/meteor/
WORKDIR /home/app/meteor/
RUN meteor build . && \
    tar -xzf meteor.tar.gz -C ../ --strip-components 1

# Remove MeteorJS app, need just the bundle version
RUN rm -r /home/app/meteor/

# Install NPM modules
WORKDIR /home/app/programs/server
RUN npm install

# Open container port
EXPOSE 3000

# User "app" to run as non-root
USER app

# Run the app
WORKDIR /home/app
CMD ["node", "main.js"]
