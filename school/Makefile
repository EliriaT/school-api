DB_URL=postgresql://root:secret@localhost:5432/school?sslmode=disable

proto:
	protoc pkg/pb/*.proto --go_out=. --go-grpc_out=. --go-grpc_opt=require_unimplemented_servers=false

server:
	go run cmd/main.go

network:
	docker network create school-network

postgres:
	docker run --name postgres12 --network school-network -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

restartpg:
	docker restart postgres12

stopdb:
	docker stop postgres12

createdb:
	docker exec -it postgres12 createdb --username=root --owner=root school

dropdb:
	docker exec -it postgres12 dropdb school

test:
	go test -v -cover ./...

dockerImage:
	docker build -t school-service .

dockerContainer:
	docker run  -p 8081:8081 --name school-service school-service
