# devcontainer

This is documentation for working with this repo inside of a [Development Container](https://containers.dev/)

## To build the devcontainer

This documentation assumes you are using VSCode, although any dev container compatible editor should work. You will also need [docker](https://docs.docker.com/engine/install/). You will also need the [Dev Containers plugin](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) for vscode, which you should be prompted to install this recommended plugin when you open the repository.

With all the dependencies installed, and this repo opened in VSCode, press `ctrl`+`shift`+`p` to open the vscode prompt. Type `Dev Containers: Rebuild and Reopen in container` and press `enter`

This will start pulling the image, and installing the configured features. It may take some time to build the initial image, but docker caching will help a bit on subsequent runs, but ymmv.

## To develop inside of the devcontainer

Once the container is up, you can run `make` to build the app inside of docker.

## git signing inside of the container

If you are on Windows/WSL and you want to setup commit signing, try this <https://stackoverflow.com/questions/62228420/signing-git-commits-on-remote-vscode-session>


