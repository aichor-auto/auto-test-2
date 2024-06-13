ARG JFROG_BASE_REPOSITORY
ARG JFROG_URL

FROM $JFROG_URL/$JFROG_BASE_REPOSITORY/python:3.8-slim

RUN --mount=type=secret,id=_env,dst=/etc/secrets/.env . /etc/secrets/.env \
    &&  pip install $PIP_INDEX_URL tensorboardX boto3

WORKDIR /app
COPY ./src ./src
COPY main.py .
