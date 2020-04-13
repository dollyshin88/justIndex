FROM python:3.7-alpine

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

ENV MULTIDICT_NO_EXTENSIONS=1
ENV YARL_NO_EXTENSIONS=1

WORKDIR /usr/src/app

RUN apk add --no-cache python3-dev libstdc++ postgresql-dev && \
    apk add --no-cache --virtual .build-deps g++ && \
    ln -s /usr/include/locale.h /usr/include/xlocale.h && \
    pip3 install psycopg2-binary && \
    apk del .build-deps

RUN pip install --upgrade pip
RUN pip install pipenv
COPY ./Pipfile ./Pipfile
COPY ./Pipfile.lock ./Pipfile.lock
RUN pipenv install --system --deploy --ignore-pipfile

# copy app
COPY justIndex ./justIndex/
COPY ./manage.py ./manage.py
COPY ./etc/entrypoint.sh ./entrypoint.sh

ENTRYPOINT ["/usr/src/app/entrypoint.sh"]

CMD ["python", "manage.py", "runserver_plus", "--nopin", "0.0.0.0:80"]



# PyPI contains binary wheels for Linux, Windows and MacOS. If you want to install multidict on another operation system (or Alpine Linux inside a Docker) the Tarball will be used to compile the library from sources. It requires C compiler and Python headers installed.

# To skip the compilation please use MULTIDICT_NO_EXTENSIONS environment variable, e.g.: