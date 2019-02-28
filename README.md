# Cruise Control docker image

This is a docker image that will build and run Cruise Control on first run and then just run it on subsequent runs.

### Instructions
You should specify a VERSION environment variable to match cruise control releases.
You should volume/bind mount a [configuration directory](https://github.com/linkedin/cruise-control/tree/master/config) to /etc/cruise-control/ (don't forget trailing slash since this is symlink to another path) with your own configuration files.

###### Example

Pull image:
```
docker pull deltaprojects/cruise-control:latest
```

Run container:
```
docker run -e "VERSION=0.1.38" -v /etc/cruise-control:/etc/cruise-control/ deltaprojects/cruise-control:latest
```
