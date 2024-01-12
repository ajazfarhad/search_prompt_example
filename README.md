# README
A search prompt application that makes use of [Typesense](https://typesense.org/) as a search engine.
## Running locally
 ``docker-compose up --build``

Bash into the web container to execute a rake task to load and index the sample data.<br/> 
``docker exec -it <web_container_id> bash`` <br/> 
run the rake task <br/> 
``rake prompt_data:load``

<br/> 

![search demo][Search.gif]
