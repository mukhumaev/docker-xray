# Builder
FROM golang:1.24-alpine AS builder

LABEL maintainer="mukhumaev <47594681+mukhumaev@users.noreply.github.com>"
LABEL version="latest"

WORKDIR /app

RUN apk add --no-cache git

RUN git clone https://github.com/XTLS/Xray-core .     && \
    git checkout $(git rev-list --tags --max-count=1) && \
    go mod download -x                                && \
    CGO_ENABLED=0 go build \
        -o xray            \
        -trimpath          \
        -buildvcs=false    \
        -ldflags="-s -w -buildid=" \
        -v ./main

RUN adduser -u 1000 -D -h /nonexistent -s /sbin/nologin xray

# App
FROM scratch AS app

COPY --from=builder /app/xray   /xray
COPY --from=builder /etc/passwd /etc/passwd

VOLUME [/etc/xray]

USER xray

ENTRYPOINT ["/xray"]

CMD ["-confdir", "/etc/xray/"]
