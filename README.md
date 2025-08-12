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

In order to provide some real world problems in communatication language, curriculum and pratices planned in collaboration with an AI assistant, with carefully designed exercises that gradually increase in complexity. Rules were simple, 
- Each SQL exercise must start with a Topic Header.
- Provide a human-readable Exercise Title that includes a difficulty level.
- The exercise description should be written in full sentences, avoiding bullet points or list formats.
- Include a Curriculum Reminder explaining the concept being practiced.
- Most exercises should be medium difficulty, but every 3rd or 4th exercise should be hard or complex.
- Maintain the same writing style used previously: full paragraphs, clear context.
- For Chapter C (Advanced SQL Patterns), include a lecture section before each exercise, while still applying the above rules.

Lastly, I followed some rules while practicing. Mostly create the structure that consists of, 
- Lecture Topic 
- Lecture Content
- Exercise Topic | Difficulty
- Exercise Title
- Exercise Description, Requirements and Data Presentation Rules
- Given Hints
- Problem Solving: Using the schema presentation try to design the solution before writing scripts

See [Advanced Example 1](./exercises/c-advanced-sql-patterns/rolling_30_days_customer_spend_tracker.sql) and [Advanced Example 2](./exercises/c-advanced-sql-patterns/cumulative_spendings_per_customer_over_time.sql) to observe solving patterns.

Also the curriculum was as shown:

A. Basics (✅ )
These exercises introduce:
* SELECT, FROM, WHERE, ORDER BY
* Simple JOINs (mostly INNER JOIN)
* Basic GROUP BY with COUNT, SUM, AVG, etc.
* Filtering groups using HAVING
* Sorting, limiting results
* Simple date filters and column extractions (EXTRACT(MONTH FROM ...))
You're currently wrapping up this section — combining joins and aggregations confidently.

B. Intermediate Logic & Multi-Table Aggregations (✅)
This block focuses on:
* Complex JOIN chains (4+ tables)
* Proper use of DISTINCT, nested aggregations
* Aliases, column renaming for clarity
* Precise filtering with HAVING
* Connecting normalized data (e.g., customer → rental → inventory → film → category)
* Performance-aware choices (avoiding over-joining or mis-aggregating)
You are now practicing professional-level query design using relational reasoning.

C. Advanced SQL Patterns (⚙️ Currrently Here)

* WITH (CTEs) for modular queries
* Subqueries inside SELECT, FROM, and WHERE
* Window functions (ROW_NUMBER, RANK, SUM() OVER(...))
* Set operations (UNION, INTERSECT, EXCEPT)
* CASE statements for conditional logic

D. Edge Cases, Performance & Robustness
In the final stage:
* Handle nulls, missing data, inconsistent schemas
* Deal with duplicates, LEFT JOIN vs INNER JOIN behavior
* Introduce basic query optimization tips
* Ensure queries still work under schema evolution
* Think about indexes, data distribution and cost in real-world querying