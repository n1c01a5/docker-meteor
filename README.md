# MeteorJS on Docker
This Docker Image will add your MeteorJS app folder, build the bundle and run it.  

## How To Use
So, just use this folder structure:  
```
my_cool_app
  - /app #Here the meteor app
  - Dockerfile #cloned from this example
  - docker-compose.yml #If you want use that
  - ...
```

**Dockerfile:**
```
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
```

**Docker-compose.yml (optional):**  
```
meteor:
  build: .
  ports:
    - "3000:3000"
  environment:
    PORT: "3000"
    ROOT_URL: "http://localhost:3000"
    MONGO_URL: "mongodb://user:pass@mongo.server:port/database"
```
*Add your database informations, use MongoDB out of this container.*  

***

If you want to use with **CI** case *(Continuous Integration)*.  
**Dockerfile-ci:**  
```
# MeteorJS App on Docker - CI version
FROM jadsonlourenco/docker-meteor-base

# Clone your repository - Comment this if use next method
RUN git clone https://github.com/meteor/simple-todos.git /home/app/meteor/

# Or add your repository as file - Uncomment this block and comment the Git method
#RUN wget https://github.com/meteor/simple-todos/archive/master.zip && \
#    unzip master.zip -d /home/app/ && \
#    mv /home/app/simple-todos-master/ /home/app/meteor/

# Build MeteorJS bundle app (NodeJS app)
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
```
*Change the GIT repo, or use WGET method, just comment/uncomment some lines self explained.*  

**Docker-compose.yml (optional):**  
```
meteor:
  build: .
  dockerfile: Dockerfile-ci
  ports:
    - "3000:3000"
  environment:
    PORT: "3000"
    ROOT_URL: "http://localhost:3000"
    MONGO_URL: "mongodb://user:pass@mongo.server:port/database"
```  

## Issues:
1. Docker is better to run **Containers** not for disposable VMs, so the ideal is to have a Docker Image just with your app code (bundle) and dependencies (NodeJS+NPM), some tiny images like Alpine Linux (+/-7mb) is good for that, but Meteor is not compatible yet (https://github.com/meteor/meteor/issues/3666).
2. **Don't have MongoDB in this container!** Yes, container is *disposable*, so I recommend that you use your database service out of container, like in "real server", will not will lost your data.
3. This Docker images can be used for production? Yes, I hope so, but this case maybe not work for all people, so if you want a "automatically" way that with a simple command *build and run** your app on Docker can use this Image.
4. NodeJS version is 0.10, soon I hope that MeteorJS support NodeJS 0.12.  

## License
None! Use as you want and like.  

### By
Jadson Lourenço - [@jadsonlourenco](https://twitter.com/jadsonlourenco)  
*"Quem tem verdadeiros ideais não sonha."*
