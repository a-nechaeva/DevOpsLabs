FROM python

ADD . /simple_app

RUN pip install flask

WORKDIR /simple_app

EXPOSE 5000

CMD python simple_app.py