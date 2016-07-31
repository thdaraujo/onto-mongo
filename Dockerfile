FROM python:2.7
ADD . /onto-mongo
WORKDIR /onto-mongo
RUN pip install -r requirements.txt
