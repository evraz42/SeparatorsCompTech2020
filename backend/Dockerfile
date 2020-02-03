FROM golang:alpine AS builder

ARG METRICS_ADDRESS=":2112"
ARG WS_ADDRESS=":2092"

RUN apk update && apk add git
COPY . $GOPATH/src/evraz/SeparatorsCompTech2020/backend
WORKDIR $GOPATH/src/evraz/SeparatorsCompTech2020/backend

RUN go get -d -v

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -ldflags="-w -s" -o /go/bin/backend

FROM scratch

COPY --from=builder /go/bin/backend /go/bin/backend
COPY --from=builder $GOPATH/src/evraz/SeparatorsCompTech2020/backend/config.yml /go/bin/backend

EXPOSE $METRICS_ADDRESS
EXPOSE $WS_ADDRESS

ENTRYPOINT ["/go/bin/backend"]