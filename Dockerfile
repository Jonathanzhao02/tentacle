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
RUN cargo rustc -- \
    -C passes='sancov' \
    -C llvm-args='-sanitizer-coverage-level=3' \
    -C llvm-args='-sanitizer-coverage-inline-8bit-counters' \
    -Z sanitizer=address \
    --bin yamux_frame_codec

# Package Stage
FROM --platform=linux/amd64 rust:latest

## TODO: Change <Path in Builder Stage>
COPY --from=builder /tentacle/fuzz/target/debug/yamux_frame_codec /

