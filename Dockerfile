FROM python:3.10-alpine

WORKDIR /app/

# Installing Dependencies
RUN apk update && \
    apk add \
        git \
        wget && \
    python -m pip install --upgrade pip

# Configure Runtime Env
ENV ERROR_REPORTING=FALSE
ENV PIP_IGNORE_INSTALLED=0

RUN adduser -D sd-runner

# Installing Stable-Diffusion WebUI
COPY --chown=sd-runner ./ /app/

USER sd-runner

VOLUME [ "/app/" ]
ENTRYPOINT [ "python", "/app/launch.py", "$@" ]