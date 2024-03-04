# Microsoft Data Stack

This repo demonstrates architecture of a data warehouse using Microsoft Data stack. It is not meant to be a drop in solution. There is an app that produces data. This is translated into a star schema data warehouse which has a SSAS tabular model which aggregates data. 

I will demonstrate "as code" principles throughout. Start with this readme file, and then explore the links to other parts of the codebase.

### User Story

As a data professional, I often encounter MS SQL instances and other ancillary MS products. As of 2024, I do not believe a microsoft certificate would demonstrate the type of knowledge that organizations need to manage their MS data stack. I would like to have a git repo that I can use as a playground for documenting and modeling my thoughts on how I "do data with microsoft".

#### Components

##### App

Will be a powershell script to generate data/schema changes to start. We are going to mock up data to demonstrate recurring workloads on the database.

##### App SQL database

This database is generated via ORM tools from the app. Our tools will read data and load it into our Data Warehouse. This is our primary data source for the data warehouse. We will also keep changes to the schema updated in our source code and discuss **why** we want to do that.

##### Data Warehouse

Any design constrains some of the answers that can be answered in a data warehouse. I talk about what I see as constraints, in the limited example(s) we integrate.

##### SSAS - Tabular

This is going to be hard to do "as code". It will start with documentation on:

- partitioning strategy
  - Dates are easy! Include an example of "transaction date" style partitioning and something based on source IDs.
- refresh button

##### Monitoring

This really should be first, but I don't think you would still be reading this if I structured it that way. I want to have actionable, real time data to help me troubleshoot issues and introduce changes in an intelligent manner.  This will include the use of [Ola Hallengren's sql maintenance solution](https://ola.hallengren.com/), [Brent Ozar's SQL server first responder kit](https://github.com/BrentOzarULTD/SQL-Server-First-Responder-Kit) and the prometheus stack.

### How To Build

You need gnu bash and docker.

I used vs code, gnu make, powershell 7+ to develop this. The jobs that will make up the ETL and general automation use powershell 7. Follow the [Makefile targets](Makefile) and please open a ticket if you run into issues and would like me to improve the documentation/code.

I include a [vs code devcontainer](./.devcontainer/devcontainer.json) specification file to allow people to get an working environment quickly.

We trust in the CI. Refer to our [Continuous Integration](docs/%20Continuous%20Integration.md) documentation and [code](BuildTools) to understand more about how to build this project.

#### SQL

You will need a `.sql.env` file with the SA password. Using the default `make` target will create one with the default password. Read up on [sql more here](./docs/SQL.md)

#### Documentation

The documentation is UTF-8 markdown files and should be editable in any text editor. 

You will need [structurizr cli](https://github.com/structurizr/cli) and [plantuml](https://github.com/plantuml/plantuml) to generate the architecture diagrams that are linked throughout. [structurizr lite](https://github.com/structurizr/lite) can be used to run a local web server that provides an interactive view of these diagrams which is not needed, but pretty useful.
