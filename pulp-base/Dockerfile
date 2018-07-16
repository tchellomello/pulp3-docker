FROM python:3.6-alpine

LABEL maintainer="Tchello Mello <tchello.mello@gmail.com>"

# build environments
ENV RQ_HOTFIX_URL="git+https://github.com/rq/rq.git@3133d94b58e59cb86e8f4677492d48b2addcf5f8#egg=rq" \
    PULP_GIT="https://github.com/pulp/pulp.git" \
    PULP_SETTINGS="/nightly/pulp/pulpcore/pulpcore/etc/pulp/server.yaml" \
    DJANGO_SETTINGS_MODULE="pulpcore.app.settings" \
    FIRST_RUN=".first_run"

# user enviroments
ENV PULP_DJANGO_DEBUG="True" \
    PULP_DB_ENGINE="django.db.backends.postgresql_psycopg2" \
    PULP_DB_NAME="pulp" \
    PULP_DB_USERNAME="pulp" \
    PULP_DB_PASSWORD="" \
    PULP_DB_HOST="127.0.0.1" \
    PULP_DB_PORT="5432" \
    PULP_REDIS_HOST="127.0.0.1" \
    PULP_REDIS_PORT="6379" \
    PULP_REDIS_PASSWORD="" 

# define workdir
WORKDIR /nightly

# install pre-reqs
RUN apk add --update \
    bash \
    build-base \
    gcc \
    git \
    libpq \
    musl \
    musl-dev \
    postgresql \
    postgresql-dev \
    python3-dev

# install pulp nightly
RUN pip install ${RQ_HOTFIX_URL} \
    && git clone ${PULP_GIT} \
    && pip install -e pulp/pulpcore \
    && pip install -e pulp/common \
    && pip install -e pulp/plugin

ADD run.sh ${WORKDIR} 
ADD docker-entrypoint.sh ${WORKDIR} 
ADD server.yaml ${PULP_SETTINGS}

RUN chmod 755 run.sh docker-entrypoint.sh \
    && touch ${FIRST_RUN}

ENTRYPOINT [ "/nightly/docker-entrypoint.sh" ]

CMD ["/run.sh"]
