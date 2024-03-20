# Extract files out of docker image
```
docker image save my_image:latest | tar xvf - | grep layer.tar | xargs -i tar xvf {} 
```
