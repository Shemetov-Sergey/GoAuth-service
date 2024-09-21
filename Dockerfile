FROM golang:alpine as builder

WORKDIR /GoAuth-service

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main ./cmd/

FROM alpine

WORKDIR /GoAuth-service

COPY --from=builder /GoAuth-service/main /GoAuth-service/main
COPY --from=builder /GoAuth-service/pkg/config/envs/*.env /GoAuth-service/

RUN chmod +x /GoAuth-service

CMD ["./main"]