# Build Stage
FROM --platform=linux/amd64 rust:latest as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake clang

## Add source code to the build stage.
ADD . /tentacle
WORKDIR /tentacle

## Build instructions
WORKDIR fuzz
RUN cargo build --bin yamux_frame_codec --release

# Package Stage
FROM --platform=linux/amd64 rust:latest

## TODO: Change <Path in Builder Stage>
COPY --from=builder /tentacle/fuzz/target/release/yamux_frame_codec /

