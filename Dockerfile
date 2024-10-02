FROM golang:bullseye AS build
WORKDIR /app
RUN apt-get update && apt-get install upx -y
COPY go.* /app/
RUN go mod download
COPY . .
ENV CGO_ENABLED=0
RUN go build -o garbage 
RUN upx garbage

FROM gcr.io/distroless/static-debian11
COPY --from=build /app/garbage /garbage
ENTRYPOINT ["/garbage"]