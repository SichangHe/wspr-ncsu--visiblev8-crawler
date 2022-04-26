FROM python:3-slim

WORKDIR /app

# Create vv8 user
RUN groupadd -g 1001 -f vv8; \
    useradd -u 1001 -g 1001 -s /bin/bash -m vv8
ENV PATH="${PATH}:/home/vv8/.local/bin"

WORKDIR /app
RUN chown -R vv8:vv8 /app

USER vv8

ENV PYTHONPATH "${PYTHONPATH}:/app"

# web server python requirements
COPY --chown=vv8:vv8 ./requirements.txt ./web_server_requirements.txt
RUN pip install --no-cache-dir --upgrade -r ./web_server_requirements.txt
# task queue requirements
# COPY --chown=vv8:vv8 task_queue/requirements.txt ./task_queue_requirements.txt
# RUN pip install --no-cache-dir --upgrade -r ./task_queue_requirements.txt

COPY --chown=vv8:vv8 ./vv8web ./vv8web
COPY --chown=vv8:vv8 ./tests ./tests

EXPOSE 80/tcp

# CMD uvicorn vv8web.server:app --host 0.0.0.0 --port 80

# python test file, Compose up docker, remote connect on VS Code
# command to run file (so far): sudo docker build -f ./web_server.test.dockerfile -t web_server_test ./
RUN python3 -m unittest discover -s ./tests/unit -t ./
