DB_URL=postgresql://root:secret@localhost:5433/lessons?sslmode=disable

proto:
	protoc pkg/pb/*.proto --go_out=. --go-grpc_out=. --go-grpc_opt=require_unimplemented_servers=false

server:
	go run cmd/main.go

network:
	docker network create school-network

postgres:
	docker run --name postgres123 --network school-network -p 5433:5433 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

restartpg:
	docker restart postgres123

createdb:
	docker exec -it postgres123 createdb --username=root --owner=root lessons

dropdb:
	docker exec -it postgres12 dropdb lessons

test:
	go test -v -cover ./...
