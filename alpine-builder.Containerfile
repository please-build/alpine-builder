# alpine:3.22.2
FROM --platform=$BUILDPLATFORM alpine@sha256:4b7ce07002c69e8f3d704a9c5d6fd3053be500b7f1c69fc0d80990c2ad8dd412

USER root

# Install dependencies for:
RUN apk --no-cache add \
# - Please
    bash curl git \
# - cc-rules (build-time)
    binutils gcc g++ musl-dev \
# - cc-rules (tests only)
    file \
# - python-rules (build-time)
    python3 python3-dev py3-pip

# Create a non-root user (that can still run commands as root if required), and use it by default.
# This is identical to how the GitHub-hosted runners are configured.
RUN apk --no-cache add sudo && \
    adduser -D runner && \
    echo runner:runner | chpasswd && \
    echo 'Defaults:runner !requiretty' > /etc/sudoers.d/runner && \
    echo 'runner ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/runner && \
    chmod 0440 /etc/sudoers.d/runner
USER runner
WORKDIR /home/runner

CMD ["/bin/bash"]
