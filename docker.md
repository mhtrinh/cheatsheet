# Extract files out of docker image
```
docker image save my_image:latest | tar xvf - | grep layer.tar | xargs -i tar xvf {} 
```

# Docker build and ssh
- Run the build with: `--ssh default` and use build kit. Example: `DOCKER_BUILDKIT=1 docker build --ssh default -t $IMAGE .`
- Make sure that your terminal from which you are running docker build, have ssh-agent "loaded". Test with `ssh-add -l`.
  - `ssh-add -D` to clear them all
  - `ssh-agent -s` to start new one
  - Multi agent can be running. Do a `ps -auxf` and kill as needed. Different terminal can have different agent, especially with vscode !
- Inside your Dockerfile, make sure to have `RUN mkdir -p -m 0700 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts` 
