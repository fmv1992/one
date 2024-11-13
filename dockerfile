FROM ubuntu@sha256:9101220a875cee98b016668342c489ff0674f247f6ca20dfc91b91c0f28581ae

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG DEBIAN_FRONTEND=noninteractive

ARG PROJECT
run set -x ; [[ -n $PROJECT ]]
ENV PROJECT $PROJECT

# Create an unpriviledged user. --- {{{

RUN apt-get update \
        && apt-get install --yes \
            dumb-init \
            sudo \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*


ARG USER_UID
RUN set -x ; [[ -n $USER_UID ]]
ARG USER_GID
RUN set -x ; [[ -n $USER_GID ]]
RUN groupadd --system --gid $USER_GID user_one \
        && useradd --no-log-init --create-home --system --gid $USER_GID user_one

# Set up sudo.
RUN echo "user_one ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/user_one \
        && chmod 0440 /etc/sudoers.d/user_one

# --- }}}

# ???. --- {{{

# --- }}}

# Switch to regular user.
USER user_one
ENV HOME /home/user_one
RUN mkdir -p $HOME

COPY --chown=user_one:user_one . $HOME/$PROJECT

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
