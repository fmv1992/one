ARG BASE_IMAGE

# Select the fastest ubuntu mirror. --- {{{

FROM ${BASE_IMAGE} AS mirror-updater
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ARG DEBIAN_FRONTEND=noninteractive
ENV PIP_BREAK_SYSTEM_PACKAGES=1

ADD --chmod=0755 \
        https://gist.githubusercontent.com/fmv1992/fd423b486f4a75fe81a6d6bfff2abdc6/raw/apt_mirror_updater \
        /tmp/apt_mirror_updater
RUN bash /tmp/apt_mirror_updater && rm /tmp/apt_mirror_updater
# RUN echo 'IyEgL3Vzci9iaW4vZW52IGJhc2gKIwojIFVwZGF0ZSB0byB0aGUgZmFzdGVzdCBtaXJyb3JzLgojCiMgKiBHaXN0OiA8aHR0cHM6Ly9naXN0LmdpdGh1YnVzZXJjb250ZW50LmNvbS9mbXYxOTkyL2ZkNDIzYjQ4NmY0YTc1ZmU4MWE2ZDZiZmZmMmFiZGM2L3Jhdy84OGJhYWI4NjY3OGQ3Y2NhZjk4ZWU1Y2MxNGFmZmU1YWM4ZjJjMGFjL2FwdF9taXJyb3JfdXBkYXRlcj4uCiMKIyAjIEhpc3RvcnkKIwojICogMjAyNS0wOC0yNDogYDIxN2U3YThgOiBmaXJzdCB3b3JraW5nIHZlcnNpb24uCiMKIyAqIDIwMjUtMDgtMjU6IGBmNDcyNzE3YDogaW1wcm92ZSBkb2NrZXIgY29weS9wYXN0ZSBjb2RlLgojCiMgKiAyMDI1LTA5LTA2OiBgMWJkYmY4OWA6IGFkZCBtdWx0aXBsZSBtZXRob2RzIGZvciBtaXJyb3Igc2VsZWN0aW9uLgojCiMgKiAyMDI2LTAyLTEyOiBgMGU1NzFmM2A6IHN0YWJsZSB2ZXJzaW9uLgojCiMgT24gZG9ja2VyOgojCiMgYGBgCiMgQVJHIEJBU0VfSU1BR0UKIwojICMgU2VsZWN0IHRoZSBmYXN0ZXN0IHVidW50dSBtaXJyb3IuIC0tLSB7e3sKIwojIEZST00gJHtCQVNFX0lNQUdFfSBBUyBtaXJyb3ItdXBkYXRlcgojIFNIRUxMIFsiL2Jpbi9iYXNoIiwgIi1vIiwgInBpcGVmYWlsIiwgIi1jIl0KIyBBUkcgREVCSUFOX0ZST05URU5EPW5vbmludGVyYWN0aXZlCiMgRU5WIFBJUF9CUkVBS19TWVNURU1fUEFDS0FHRVM9MQojCiMgQUREIC0tY2htb2Q9MDc1NSBcCiMgICAgIGh0dHBzOi8vZ2lzdC5naXRodWJ1c2VyY29udGVudC5jb20vZm12MTk5Mi9mZDQyM2I0ODZmNGE3NWZlODFhNmQ2YmZmZjJhYmRjNi9yYXcvODhiYWFiODY2NzhkN2NjYWY5OGVlNWNjMTRhZmZlNWFjOGYyYzBhYy9hcHRfbWlycm9yX3VwZGF0ZXIgXAojICAgICAvdG1wL2FwdF9taXJyb3JfdXBkYXRlcgojIFJVTiBiYXNoIC90bXAvYXB0X21pcnJvcl91cGRhdGVyICYmIHJtIC90bXAvYXB0X21pcnJvcl91cGRhdGVyCiMKIyBGUk9NICR7QkFTRV9JTUFHRX0KIyBTSEVMTCBbIi9iaW4vYmFzaCIsICItbyIsICJwaXBlZmFpbCIsICItYyJdCiMgQVJHIERFQklBTl9GUk9OVEVORD1ub25pbnRlcmFjdGl2ZQojIEVOViBQSVBfQlJFQUtfU1lTVEVNX1BBQ0tBR0VTPTEKIwojIENPUFkgLS1mcm9tPW1pcnJvci11cGRhdGVyIC9zb3VyY2VzLmxpc3QgL2V0Yy9hcHQvc291cmNlcy5saXN0CiMKIyBTSEVMTCBbIi9iaW4vYmFzaCIsICItbyIsICJwaXBlZmFpbCIsICItYyJdCiMKIyAjIC0tLSB9fX0KIwojIGBgYAojIEhhbHQgb24gZXJyb3IuCnNldCAtZXV4byBwaXBlZmFpbAoKIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjCiMgUmVzdG9yZSBvcmlnaW5hbCBzb3VyY2VzLmxpc3Qgb24gZmFpbHVyZS4KIyBHbG9iYWxzOgojICAgTm9uZS4KIyBBcmd1bWVudHM6CiMgICBOb25lLgojIE91dHB1dHM6CiMgICBXcml0ZXMgdG8gc3RkZXJyIG9uIGZhaWx1cmUuCiMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIwpmdW5jdGlvbiBjbGVhbnVwKCkgewogICAgbG9jYWwgZXhpdF9jb2RlPSQ/CiAgICBpZiBbWyAke2V4aXRfY29kZX0gLW5lIDAgXV0gJiYgW1sgLWYgL2V0Yy9hcHQvc291cmNlcy5saXN0LmJhY2t1cCBdXTsgdGhlbgogICAgICAgIGNwIC9ldGMvYXB0L3NvdXJjZXMubGlzdC5iYWNrdXAgL2V0Yy9hcHQvc291cmNlcy5saXN0CiAgICAgICAgZWNobyAiUmVzdG9yZWQgb3JpZ2luYWwgc291cmNlcy5saXN0IGZyb20gYmFja3VwLiIgPiAvZGV2L3N0ZGVycgogICAgZmkKfQp0cmFwIGNsZWFudXAgRVhJVCBJTlQgVEVSTSBIVVAKCmlmIFtbICQod2hvYW1pKSAhPSAncm9vdCcgXV07IHRoZW4KICAgIGVjaG8gIlRoaXMgc2hvdWxkIGJlIHJ1biBhcyByb290LiIgPiAvZGV2L3N0ZGVycgogICAgZXhpdCAxCmZpCgojIElkZW1wb3RlbmN5OiBpZiAvc291cmNlcy5saXN0IGFscmVhZHkgZXhpc3RzLCB0aGUgc2NyaXB0IGhhcyBhbHJlYWR5CiMgY29tcGxldGVkIHN1Y2Nlc3NmdWxseS4KaWYgW1sgLWYgL3NvdXJjZXMubGlzdCBdXTsgdGhlbgogICAgZWNobyAiTWlycm9yIGFscmVhZHkgY29uZmlndXJlZCAoL3NvdXJjZXMubGlzdCBleGlzdHMpLiBTa2lwcGluZy4iID4gL2Rldi9zdGRlcnIKICAgIGV4aXQgMApmaQoKZnVuY3Rpb24gbWFpbl9hcHRfc21hcnQoKSB7CiAgICBhcHQtZ2V0IHVwZGF0ZQogICAgYXB0LWdldCBpbnN0YWxsIFwKICAgICAgICAtLXllcyBcCiAgICAgICAgLS1uby1pbnN0YWxsLXJlY29tbWVuZHMgXAogICAgICAgIGNhLWNlcnRpZmljYXRlcyBcCiAgICAgICAgbHNiLXJlbGVhc2UgXAogICAgICAgIHB5dGhvbjMgXAogICAgICAgIHB5dGhvbjMtcGlwCiAgICBweXRob24zIC1tIHBpcCBpbnN0YWxsIC0tbm8tY2FjaGUtZGlyIGFwdC1zbWFydAogICAgIyBgaHR0cGAgaXMgZmluZTogPGh0dHBzOi8vYXNrdWJ1bnR1LmNvbS9hLzM1Mjk3Mj4uCiAgICBhcHQtc21hcnQgXAogICAgICAgIC0tYXV0by1jaGFuZ2UtbWlycm9yIFwKICAgICAgICAtLWV4Y2x1ZGUgJypkZWIuY2FtcG9sYXJnby5wci5nb3YuYnIqJyBcCiAgICAgICAgLS1leGNsdWRlICcqdWJ1bnR1LmxldHNjbG91ZC5pbyonIFwKICAgICAgICAtLWV4Y2x1ZGUgJypzZnQuaWYudXNwLmJyKicKICAgICMgVmVyaWZ5IHRoZSBuZXcgc291cmNlIHdvcmtzLgogICAgYXB0LWdldCB1cGRhdGUKfQpmdW5jdGlvbiBtYWluX21pcnJvcl9saXN0KCkgewogICAgIyBKYW1teSBleGFtcGxlOyByZXBsYWNlICRjb2RlbmFtZSBpZiB5b3UncmUgb24gYW5vdGhlciByZWxlYXNlCiAgICBjb2RlbmFtZXM9IiQoLiAvZXRjL29zLXJlbGVhc2UgJiYgZWNobyAiJHtWRVJTSU9OX0NPREVOQU1FfSIpIgogICAgdGVlIC9ldGMvYXB0L3NvdXJjZXMubGlzdCA+IC9kZXYvbnVsbCA8PCBFT0YKZGViIG1pcnJvcitodHRwOi8vbWlycm9ycy51YnVudHUuY29tL21pcnJvcnMudHh0ICR7Y29kZW5hbWVzfSBtYWluIHJlc3RyaWN0ZWQgdW5pdmVyc2UgbXVsdGl2ZXJzZQpkZWIgbWlycm9yK2h0dHA6Ly9taXJyb3JzLnVidW50dS5jb20vbWlycm9ycy50eHQgJHtjb2RlbmFtZXN9LXVwZGF0ZXMgbWFpbiByZXN0cmljdGVkIHVuaXZlcnNlIG11bHRpdmVyc2UKZGViIG1pcnJvcitodHRwOi8vbWlycm9ycy51YnVudHUuY29tL21pcnJvcnMudHh0ICR7Y29kZW5hbWVzfS1iYWNrcG9ydHMgbWFpbiByZXN0cmljdGVkIHVuaXZlcnNlIG11bHRpdmVyc2UKZGViIG1pcnJvcitodHRwOi8vbWlycm9ycy51YnVudHUuY29tL21pcnJvcnMudHh0ICR7Y29kZW5hbWVzfS1zZWN1cml0eSBtYWluIHJlc3RyaWN0ZWQgdW5pdmVyc2UgbXVsdGl2ZXJzZQpFT0YKICAgICMgVmVyaWZ5IHRoZSBuZXcgc291cmNlIHdvcmtzLgogICAgYXB0LWdldCB1cGRhdGUKfQpmdW5jdGlvbiBtYWluX2FwdF9zZWxlY3QoKSB7CiAgICBhcHQtZ2V0IHVwZGF0ZQogICAgYXB0LWdldCBpbnN0YWxsIFwKICAgICAgICAtLXllcyBcCiAgICAgICAgLS1uby1pbnN0YWxsLXJlY29tbWVuZHMgXAogICAgICAgIGNhLWNlcnRpZmljYXRlcyBcCiAgICAgICAgY3VybCBcCiAgICAgICAgbHNiLXJlbGVhc2UgXAogICAgICAgIHB5dGhvbjMgXAogICAgICAgIHB5dGhvbjMtcGlwCiAgICBweXRob24zIC1tIHBpcCBpbnN0YWxsIC0tbm8tY2FjaGUtZGlyIGFwdC1zZWxlY3QKICAgIENDPSIkKCAoY3VybCAtLWZhaWwgLS1zaWxlbnQgLS1zaG93LWVycm9yIC0tbWF4LXRpbWUgMyBodHRwczovL2lmY29uZmlnLmNvL2NvdW50cnktaXNvIFwKICAgICAgICB8fCBjdXJsIC0tZmFpbCAtLXNpbGVudCAtLXNob3ctZXJyb3IgLS1tYXgtdGltZSAzIGh0dHBzOi8vaXBhcGkuY28vY291bnRyeSBcCiAgICAgICAgfHwgY3VybCAtLWZhaWwgLS1zaWxlbnQgLS1zaG93LWVycm9yIC0tbWF4LXRpbWUgMyBodHRwczovL2lwaW5mby5pby9jb3VudHJ5IFwKICAgICAgICB8fCBjdXJsIC0tZmFpbCAtLXNpbGVudCAtLXNob3ctZXJyb3IgLS1tYXgtdGltZSAzICdodHRwczovL2lwd2hvLmlzLz9maWVsZHM9Y291bnRyeV9jb2RlJyBcCiAgICAgICAgfHwgZWNobyBVUykgfCB0ciAtY2QgJ0EtWmEteicgfCBoZWFkIC1jMiB8IHRyICdhLXonICdBLVonKSIKICAgIHRpbWVvdXQgMW0gYXB0LXNlbGVjdCAtLXRvcCA1IC0tY291bnRyeSAiJHtDQ30iCiAgICBtdiAuL3NvdXJjZXMubGlzdCAvZXRjL2FwdC9zb3VyY2VzLmxpc3QKICAgICMgVmVyaWZ5IHRoZSBuZXcgc291cmNlIHdvcmtzLgogICAgYXB0LWdldCB1cGRhdGUKfQoKIyBPbmx5IGNyZWF0ZSBiYWNrdXAgaWYgb25lIGRvZXNuJ3QgYWxyZWFkeSBleGlzdCAoaWRlbXBvdGVudCkuCmlmIFtbICEgLWYgL2V0Yy9hcHQvc291cmNlcy5saXN0LmJhY2t1cCBdXTsgdGhlbgogICAgY3AgL2V0Yy9hcHQvc291cmNlcy5saXN0IC9ldGMvYXB0L3NvdXJjZXMubGlzdC5iYWNrdXAKZmkKCm1haW5fYXB0X3NlbGVjdCB8fCBtYWluX2FwdF9zbWFydCB8fCBtYWluX21pcnJvcl9saXN0CgpjcCAvZXRjL2FwdC9zb3VyY2VzLmxpc3QgL3NvdXJjZXMubGlzdAoKIyB2aW06IHNldCBmaWxldHlwZT1zaCBmaWxlZm9ybWF0PXVuaXggbm93cmFwOgo=' | base64 --decode | sponge | bash -xv -

FROM ${BASE_IMAGE}
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ARG DEBIAN_FRONTEND=noninteractive
ENV PIP_BREAK_SYSTEM_PACKAGES=1

COPY --from=mirror-updater /sources.list /etc/apt/sources.list

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# --- }}}

ARG PROJECT
RUN set -x ; [[ -n $PROJECT ]]
ENV PROJECT $PROJECT

# Create an unpriviledged user. --- {{{

RUN apt-get update \
        && apt-get install --yes \
            curl \
            dumb-init \
            parallel \
            sudo \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

ARG USER_UID
RUN set -x ; [[ -n $USER_UID ]]
ARG USER_GID
RUN set -x ; [[ -n $USER_GID ]]
RUN groupadd --system --gid $USER_GID user_one \
        && useradd --no-log-init --create-home --system --uid $USER_UID --gid $USER_GID user_one

# Set up sudo.
RUN echo "user_one ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/user_one \
        && chmod 0440 /etc/sudoers.d/user_one

# --- }}}

# Install nfpm for packaging. --- {{{

ADD --chmod=0644 \
        https://github.com/goreleaser/nfpm/releases/download/v2.45.0/nfpm_2.45.0_amd64.deb \
        /tmp/nfpm.deb
RUN apt-get update \
        && apt-get install --yes /tmp/nfpm.deb \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* \
        && rm /tmp/nfpm.deb
RUN nfpm --version

# Install docopts for CLI parsing in shell scripts.
ADD --chmod=0755 \
    https://github.com/docopt/docopts/releases/download/v0.6.3-rc2/docopts_linux_amd64 \
    /usr/local/bin/docopts

# --- }}}
# Switch to regular user.
USER user_one
ENV HOME /home/user_one
RUN mkdir -p $HOME

COPY --chown=user_one:user_one . $HOME/$PROJECT
# `̶R̶̶̶U̶̶̶N̶̶ ̶r̶̶̶m̶̶ ̶$̶̶̶H̶̶̶O̶̶̶M̶̶̶E̶̶̶/̶̶̶$̶̶̶P̶̶̶R̶̶̶O̶̶̶J̶̶̶E̶̶̶C̶̶̶T̶̶̶/̶̶̶n̶̶̶f̶̶̶p̶̶̶m̶̶̶.̶̶̶y̶̶̶a̶̶̶m̶̶̶l̶̶` is not necessary since the `nfpm` is
# mounted.

# Administrative settings: define commands, etc. --- {{{

WORKDIR $HOME/${PROJECT}

CMD ["bash"]
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

ARG GIT_COMMIT
RUN set -x ; [[ -n $GIT_COMMIT ]]

ARG BUILD_DATE
RUN set -x ; [[ -n $BUILD_DATE ]]

ARG GIT_COMMIT_DATE
RUN set -x ; [[ -n $GIT_COMMIT_DATE ]]

ARG IMAGE_NAME
RUN set -x ; [[ -n $IMAGE_NAME ]]

# Inject as envvars so they're accessible inside
ENV IMAGE_NAME="$IMAGE_NAME" \
        BUILD_DATE="$BUILD_DATE" \
        GIT_COMMIT="$GIT_COMMIT" \
        GIT_COMMIT_DATE="$GIT_COMMIT_DATE"

LABEL \
    org.opencontainers.image.title="$IMAGE_NAME"

# --- }}}

# vim: set filetype=dockerfile fileformat=unix nowrap spell spelllang=en,cdenglish01:
