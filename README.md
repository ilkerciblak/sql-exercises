<div align="center">
    <img src="https://www.techmonitor.ai/wp-content/uploads/sites/29/2016/06/SQL.png" height="150"/>
    <h1>PostgreSQL Exercises Repository</h1>
    <p>An educational public repository for <a href="https://postgresql.org">PostgreSQL</a>  exercises from beginner to advanced topics.</p>

![Docker](https://img.shields.io/badge/Docker-v28.3.2-blue?style=flat&logo=docker&color=gray&logoColor=white&labelColor=blue)
![Postgres Image](https://img.shields.io/badge/PostgeSQL_Image-v16.0.0-gray?style=flat&logo=postgreSQL&logoColor=white&labelColor=4169E1)
![Adminer Image](https://img.shields.io/badge/latest-gray?style=flat&logo=Adminer&labelColor=34567C&label=Adminer%20Image)


</div>

## Repository Introduction

Despite there are multiple counts of offline first or offline web or mobile applications, most of the digital tools are require data transactions. These data transactions might occur in different ways up to developers' decisions when designing the application's system and architecture of the software that they work on. As a result of this, based on business logic of the specific problem(s) that application points to, developers might need sharpen `querying skills` to develop more accurate, safe and performant data interactions.

In addition to that, after the latest deep and popular studies over `Artificial Intellegence`, `Large Language Models` or any other `Data and Machine Learning Related` studies made `Data Studies and Analysis` more important. 

That so, in order to sharpen `my` SQL knowledge and skills using [PostgreSQL](https://postgresql.org) as query language, just built a docker container that consists of `PostgreSQL` and `Adminer` images with some configurations that will be disscussed in following steps.

> [!IMPORTANT]
> [Devrim Gündüz/Pagila](https://github.com/devrimgunduz/pagila?tab=readme-ov-file): Special Thanks to [Devrim Gündüz](https://github.com/devrimgunduz) for somehow re-creating Pagila DB and publishing public repository that includes database schema presentation and initialization configurations

## Requirements and Project Setup

- **Docker**: In order to create development environment [Docker]() was used.
- **IDE**: After development environment `psql` will be run our queries. In order to conduct queries over files using `vscode` or `neovim` will be much helpfull with SQL related lsp plugins.

### Development Environment Setup and Data Initialization
In order to serve initial data, as mentioned before, [devrimgunduz/pagila](https://github.com/devrimgunduz/pagila) repository will be used. Special thanks to him, we could just deal with sharpening query knowledge phase without wasting time with data generation.

Initial database configuration is secured with the [docker-compose.yml](./docker-compose.yml) file, by means of `bind mount volumes` of  [init.db](./init/init.sql) and [docker-entrypoint-initdb.d]() (in docker container). To prevent any problem due to that init.db file, before building the container follow the guideline.



#### 1. First Change Directory to Project Folder
```bash
$ cd project_folder
```

#### 2. Download The Pagila Dataset and Schema while Overriding init.sql File
```bash

$ curl -O https://raw.githubusercontent.com/devrimgunduz/pagila/master/pagila-schema.sql
$ curl -O https://raw.githubusercontent.com/devrimgunduz/pagila/master/pagila-data.sql
$ cat pagila-schema.sql pagila-data.sql > init/init.sql

```
This commands will download the required pagila database scripts, and
override/create init.sql content.

#### 3. Build and Run Docker Container Using Compose File
In project main dir, run
```bash
$ docker-compose -f docker-compose.yml up -d --build
```
This will build and run postgres and adminer containers in detached mode.

#### 4. Using Container

Since `postgres image` will serve `psql`(terminal based client to PostgreSQL) two different mechanism can be used to query over pagila database.
##### 4.1 Creating .sql Files to Query 
Using following terminal command `.sql` files can be used to query
over pagila database.
```bash
# in container bash
$ psql -U postgres -d pagila -f relative-path/of-any-file.sql
```
where `-U` is the `POSTGES_USER` and `-d` is the `POSTGRES_DB` where we configured in [docker-compose.yml](./docker-compose.yml) file. If you changed those environment values you need to use your own values in command.

I mostly used creating query file(s) option to take them as lecture notes and to serve the excercises like real problems and their solving methods.

##### 4.2 Using Container Bash to Construct Queries

```bash
# in container bash
$ psql -U postgres -d pagila
# This will open an terminal-UI to construct queries
psql (16.9 (Debian 16.9-1.pgdg120+1))
Type "help" for help.

pagila=# 


```

Now you can construct your queries and see the outputs like following
```bash
pagila=# SELECT customer_id
pagila-# FROM customer
pagila-# LIMIT 3;
 customer_id 
-------------
           1
           2
           3
(3 rows)

```
`psql` will not start the query until a semicolon `;` is entered.


## Query Files and Curriculum

