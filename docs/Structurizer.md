# Structurizer

[Structurizer](https://structurizr.com/) is a Diagrams as Code tool that follows the C4 model. I find that using this "as code" approach results in more consistent documentation for me. The [C4 model](https://c4model.com/) that structurizer uses provides a "zoomable" diagram, which allows me to easily jump around to different parts of the solution (ie codebase) and dive back into the nuances of the chunk of work I am focusing on.

## Why I am using Structurizer?

I like that I can easily build a diagram of the small part of the overall design I am working on. I am able to iterate by editing a file, and then views the out put in the local web app. My changes are versioned with git, and it all is searchable.

## Structurizer Lite and Structurizer CLI

I am using the CLI to output png images that I can then reference in other documentation. 

I am using the Lite app to provide a local web app for me to view and navigate throughout the diagram defined in [workspace.dsl](../workspace.dsl) in this repo root. 

## Why is the Lite web app not in the Compose file?

in the [makefile](../Makefile) I wrote a target to just docker run the lite web app. This is in contrast to the [docker-compose.yml](../docker-compose.yml) that the rest of the services are in. That is because I am using the web server as I iterate and refine the domain model. I will rely on the [continuous integration](Continuous%20Integration.md) to build the images that will be embedded in my static documentation. 