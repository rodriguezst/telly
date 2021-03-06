############################
# STEP 1 build executable binary
############################
FROM golang:alpine AS builder

# Install git
RUN apk --update add git make gcc libc-dev

COPY ./ /app
WORKDIR /app

# Fetch dependencies.
# Using go get.
RUN go get -d -v && \
    go get -u github.com/prometheus/promu

# Build the binary.
RUN make

############################
# STEP 2 build a small image
############################

FROM scratch
# Copy our static executable.
COPY --from=builder /app/telly /app
EXPOSE 6077
ENTRYPOINT ["/app"]
