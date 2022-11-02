FROM ubuntu:kinetic

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
WORKDIR /app/

# Installing Dependencies
RUN apt update -y && apt install -y --no-install-recommends \
        wget \
        git \
        python3 \
        python3-pip

# Installing Nvidia Driver
RUN apt install -y --no-install-recommends \
        nvidia-driver-515-server \
    && rm -rf /var/lib/apt/lists/*

# Configure Runtime Env
ENV ERROR_REPORTING=FALSE
ENV PIP_IGNORE_INSTALLED=0

RUN useradd -ms /bin/bash sd-runner

# Installing Stable-Diffusion WebUI
COPY --chown=sd-runner ./ /app/
RUN pip install -r requirements_versions.txt

USER sd-runner
ENTRYPOINT [ "python3", "/app/launch.py", "$@" ]