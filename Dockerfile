# Build webhook in a stock Go build container
FROM golang:1.22-alpine as builder

ARG BUILD_TARGET
ARG SRC_REPO

RUN apk update && apk add --no-cache make gcc musl-dev linux-headers git bash

WORKDIR /src
RUN bash -c "git clone ${SRC_REPO} webhook && cd webhook && git config advice.detachedHead false && git fetch --all --tags && \
if [[ ${BUILD_TARGET} =~ pr-.+ ]]; then git fetch origin pull/$(echo ${BUILD_TARGET} | cut -d '-' -f 2)/head:webhook-pr; git checkout webhook-pr; else git checkout ${BUILD_TARGET}; fi && \
go build -o webhook"

# Pull all binaries into a second stage deploy container
FROM alpine:3

ARG USER=webhook
ARG UID=11000

RUN apk add --no-cache tini curl jq

# See https://stackoverflow.com/a/55757473/12429735RUN
RUN adduser \
    --disabled-password \
    --gecos "" \
    --shell "/sbin/nologin" \
    --uid "${UID}" \
    "${USER}"

RUN mkdir -p /var/lib/webhook && chown -R ${USER}:${USER} /var/lib/webhook && chmod -R 700 /var/lib/webhook

# Cannot assume buildkit, hence no chmod
COPY --from=builder --chown=${USER}:${USER} /src/webhook/webhook /usr/local/bin/
# Belt and suspenders
RUN chmod -R 755 /usr/local/bin/*

USER ${USER}

EXPOSE      9000
ENTRYPOINT  ["/sbin/tini", "--", "/usr/local/bin/webhook"]
CMD         ["-verbose", "-hotreload", "-hooks=/config/hooks.yml"]
