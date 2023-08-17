FROM golang:1.20 as build

WORKDIR /

COPY go ./go
COPY main.go .
COPY go.mod .
COPY go.sum .
COPY Makefile .

RUN make build-local

FROM scratch as runtime
WORKDIR /root/

COPY linux-api_repo_name-* api_repo_name

# Optional:
# To bind to a TCP port, runtime parameters must be supplied to the docker command.
# But we can document in the Dockerfile what ports
# the application is going to listen on by default.
# https://docs.docker.com/engine/reference/builder/#expose
EXPOSE 8080/tcp

ENTRYPOINT ["/root/api_repo_name"]