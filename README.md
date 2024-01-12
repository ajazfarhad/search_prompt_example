# README

## Running locally
 ``docker-compose up --build``

Bash into the web container to execute a rake task to load and index the sample data.
``docker exec -it <web_container_id> bash``
run the rake task
``rake prompt_data:load``
* ...
