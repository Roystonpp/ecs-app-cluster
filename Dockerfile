FROM python:3.8

COPY . /web-app /web-app/

RUN pip3 install Flask

WORKDIR /web-app

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]