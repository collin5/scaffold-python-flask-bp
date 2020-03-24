FROM python:3.8-buster

RUN pip install pipenv
COPY Pipfile Pipfile.lock ./
RUN pipenv install --system --deploy --ignore-pipfile

ENV FLASK_APP=api \
    PYTHONUNBUFFERED=1

WORKDIR /apidir

RUN useradd --system apiuser && \
    mkdir api && \
    chown -R apiuser api

USER apiuser

COPY api api

ENTRYPOINT ["gunicorn", "api:create_app()", \
            "--bind", "0.0.0.0:5000", \
            "--log-file", "-", \
            "--threads", "1", \
            "--workers", "1", \
            "--worker-class", "gthread", \
            "--worker-tmp-dir", "/dev/shm"]
