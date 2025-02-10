 ```docker-compose up -d```

```redis-cli -h 192.168.1.62 -p 6380 PING``` for test docker conteiner if you see answer ```PONG```  means docker conteiner started

```cd redis_app```

 ```mix setup```
 
 ```iex -S mix phx.server```

 Now you can visit http://localhost:4000 from your browser.