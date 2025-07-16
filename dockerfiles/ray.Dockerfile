FROM rayproject/ray:2.23.0-cpu
FROM alpine/curl AS vscode-installer

RUN mkdir /aichor
RUN curl -Lk 'https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64' --output /aichor/vscode_cli.tar.gz
RUN tar -xf /aichor/vscode_cli.tar.gz -C /aichor


# Project's Dockerfile content, for example
FROM pytorch/pytorch:2.4.1-cuda12.4-cudnn9-runtime
# ...
# Project's Dockerfile content

# Copy the vscode binary on the final Dockerfile stage at '/aichor'
# binary won't be findable in $PATH, it'll just be located at '/aichor/code'
COPY --from=vscode-installer /aichor /aichor


COPY dockerfiles/requirements.txt .
RUN pip install -r requirements.txt

WORKDIR /app
COPY ./src ./src
COPY main.py .
