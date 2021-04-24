FROM alpine

COPY . /web-app /web-app/

RUN apk add python3 py3-pip

RUN pip3 install Flask

RUN apk add --no-cache bash

WORKDIR /web-app

EXPOSE 5000

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0" ]