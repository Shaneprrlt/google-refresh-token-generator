build:
	docker-compose build

start:
	docker-compose up -d

shell:
	docker-compose exec server /bin/bash

stop:
	docker-compose down