FROM ubuntu:16.04

RUN apt-get update -y && \
    apt-get install -y python-pip python-dev

COPY ./ /web-app
WORKDIR /web-app
RUN pip install -r requirements.txt
ENTRYPOINT [ "python" ]
CMD [ "web-app/app.py" ]