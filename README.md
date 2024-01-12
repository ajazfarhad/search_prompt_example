# README
A search prompt application that makes use of [Typesense](https://typesense.org/) as a search engine.
## Running locally
 ``docker-compose up --build``

Bash into the web container to execute a rake task to load and index the sample data.<br/> 
``docker exec -it <web_container_id> bash`` <br/> 
run the rake task <br/> 
``rake prompt_data:load``

<br/> 

![Search](https://github.com/ajazfarhad/search_prompt_example/assets/49904093/1e6bce9e-d3eb-4290-96c0-9e565d4af7a8)

