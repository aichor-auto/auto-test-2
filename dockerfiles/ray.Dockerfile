FROM rayproject/ray:2.2.0-cpu

RUN pip install tensorboardX boto3

WORKDIR /app
RUN --mount=type=secret,id=_env,dst=/etc/secrets/.env . /etc/secrets/.env && echo $KEY_BUILD && echo $KEY_BUILD > value.txt

COPY ./src ./src
COPY main.py .