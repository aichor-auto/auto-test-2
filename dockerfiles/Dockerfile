FROM python:3.8-slim

RUN pip install tensorboardX boto3

RUN --mount=type=secret,id=_env,dst=/etc/secrets/.env . /etc/secrets/.env && echo $KEY_BUILD && echo $KEY_BUILD > val.txt

WORKDIR /app


COPY ./src ./src
COPY main.py .
