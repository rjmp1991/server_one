FROM golang:alpine AS build
RUN apk add --no-cache git
RUN mkdir -p /home/appuser && HOME=/home/appuser \
 && chmod -R 0755 /home/appuser    \
 && addgroup -S -g 10101 appuser   \
 && adduser -S -D -s /sbin/nologin -h /home/appuser -G appuser appuser
WORKDIR /home/appuser
COPY main.go .
COPY go.mod .
RUN go mod download
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build \
    -installsuffix 'static' \
    -ldflags="-w -s" \
    -o /home/appuser/main

FROM scratch
LABEL mainteiner="Rafael Jose Montoya <rjmp1991@gmail.com>" \
      Description="server_one" Vendor="Rafael Montoya" Version="1"
ENV TZ=America/Bogota
COPY --from=build /home/appuser/main /home/appuser/main
COPY --from=build /etc/passwd /etc/passwd
USER appuser
ENTRYPOINT [ "/home/appuser/main" ]
