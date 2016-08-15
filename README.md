# onto-mongo
Ontology for mongoDB


## The alfredo script

The ```alfredo``` script provides the following functionalities:


First: give execute permission:
```
chmod u+x script/alfredoMac
```

```
# Start docker machine
./script/alfredoMac machine

# Sets env
./script/alfredoMac env

# Builds the image from scratch
./script/alfredoMac build

# Stops and removes all containers.
./script/alfredoMac clean

# Restarts the app container if its running, starts it otherwise.
./script/alfredoMac restart

# Starts the app container.
./script/alfredoMac run

```
For more information, run the help option:
```
./script/alfredoMac help
```

The app runs at ```localhost:5000``` or ```$(docker-machine ip default):5000```.

Connecting to the shell: `docker exec -it <id> bash`
