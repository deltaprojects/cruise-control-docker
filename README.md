# Cruise Control docker image

This is a docker image that will build and run Cruise Control on first run and then just run it on subsequent runs. (Yes I know that's cheating, but it makes this image become low maintenance).

### Instructions
You should specify a VERSION environment variable to match cruise control releases.
You should volume/bind mount a [configuration directory](https://github.com/linkedin/cruise-control/tree/master/config) to /etc/cruise-control with your own configuration files (cruisecontrol.properties and capacity.json).

Cruise Control UI is downloaded to /target/cruise-control-ui. So make sure you set `webserver.ui.diskpath=/target/cruise-control-ui/` in cruisecontrol.properties.

###### Example

Pull image:
```
docker pull deltaprojects/cruise-control:latest
```

Run container:
```
docker run -e "VERSION=0.1.39" -v /etc/cruise-control:/etc/cruise-control deltaprojects/cruise-control:latest
```

### Pro Tips

* Set `webserver.accesslog.path=/proc/self/fd/1` to redirect access log to stdout, thus making it available via docker logs.
* Add a `/etc/cruise-control/ui-config.csv` if you want to adjust web ui config.

### Contribute

Write a issue or pull request.
