A learning project for microservices

Run RabbitMQ:
docker run   --rm   --name rabbitmq   -p 5672:5672   -p 15672:15672   --hostname node1   -v rabbitmq:/var/lib/rabbitmq   rabbitmq:3-management
