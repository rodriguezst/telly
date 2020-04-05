############################
# STEP 1 build executable binary
############################
FROM golang:alpine AS builder

# Install git
RUN apk --update add git

COPY ./ /app
WORKDIR /app

# Fetch dependencies.
# Using go get.
RUN go get -d -v

# Build the binary.
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /go/bin/app

############################
# STEP 2 build a small image
############################

FROM scratch
# Copy our static executable.
COPY --from=builder /go/bin/app /app
EXPOSE 6077
ENTRYPOINT ["/app"]
