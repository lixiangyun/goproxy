FROM golang:1.8.1

WORKDIR /usr1/golang
ENV GOPATH=/usr1/golang
ENV GOOS=linux
ENV CGO_ENABLED=0

RUN go get -u -v github.com/lixiangyun/goproxy/

WORKDIR /usr1/golang/src/github.com/lixiangyun/goproxy/examples/goproxy-basic/

RUN go build .

FROM alpine:latest
RUN apk --no-cache add ca-certificates

WORKDIR /root/

COPY --from=0 /usr1/golang/src/github.com/lixiangyun/goproxy/examples/goproxy-basic/goproxy-basic ./proxy

RUN chmod +x *

EXPOSE 8080

# docker build -t linimbus/goproxy_docker -f Dockerfile_goproxy .
# docker run -d -p 8080:8080 --restart=always linimbus/goproxy_docker

ENTRYPOINT ["./proxy", "-addr", ":8080"]
