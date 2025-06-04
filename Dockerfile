FROM python:3.10.4

RUN apt-get update && apt-get install -y libxslt-dev libxml2 && rm -rf /var/lib/apt/lists/*

WORKDIR /alvin-client

COPY alvin_django .

#ADD /requirements.txt .
#ADD /Pipfile .
#ADD /Pipfile.lock .

RUN pip install --no-cache-dir -r requirements.txt

RUN python manage.py collectstatic --noinput

ENV GUNICORN_WORKERS=4
ENV GUNICORN_BIND=0.0.0.0:8000
ENV GUNICORN_LOG_LEVEL=debug

EXPOSE 8000
CMD ["sh", "-c", "gunicorn -w $GUNICORN_WORKERS -k uvicorn.workers.UvicornWorker alvin_django.asgi:application --bind $GUNICORN_BIND --log-level GUNICORN_LOG_LEVEL"]
