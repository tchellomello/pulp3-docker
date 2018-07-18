#!/usr/bin/env bash

if [ -f "${FIRST_RUN}" ]; then

    # append SECRET_KEY to server.yaml
    if [ -f "$PULP_SETTINGS" ]; then
        hash=$(cat /dev/urandom | tr -dc 'a-z0-9!@#$%^&*(\-_=+)' | head -c 50)
        echo "SECRET_KEY: '$hash'" >> ${PULP_SETTINGS}
    fi

    # set debug preferences
    echo "DEBUG: $PULP_DJANGO_DEBUG" >> ${PULP_SETTINGS}

    # define REDIS backend
    sed -i 's/PULP_REDIS_HOST/'"$PULP_REDIS_HOST"'/g' $PULP_SETTINGS
    sed -i 's/PULP_REDIS_PORT/'"$PULP_REDIS_PORT"'/g' $PULP_SETTINGS
    sed -i 's/PULP_REDIS_PASSWORD/'"$PULP_REDIS_PASSWORD"'/g' $PULP_SETTINGS

    # define database backend
    sed -i 's/PULP_DB_ENGINE/'"$PULP_DB_ENGINE"'/g' $PULP_SETTINGS
    sed -i 's/PULP_DB_NAME/'"$PULP_DB_NAME"'/g' $PULP_SETTINGS
    sed -i 's/PULP_DB_USERNAME/'"$PULP_DB_USERNAME"'/g' $PULP_SETTINGS
    sed -i 's/PULP_DB_PASSWORD/'"$PULP_DB_PASSWORD"'/g' $PULP_SETTINGS
    sed -i 's/PULP_DB_HOST/'"$PULP_DB_HOST"'/g' $PULP_SETTINGS
    sed -i 's/PULP_DB_PORT/'"$PULP_DB_PORT"'/g' $PULP_SETTINGS

    # run django migrations
    # test if database is up and ready
    echo "Testing connection to PostgreSQL database...."
    pg_isready -d $PULP_DB_NAME -h $PULP_DB_HOST -U $PULP_DB_USERNAME &>/dev/null
    db_status=$(echo $?)
    if [ $db_status -eq 0 ]; then
        echo "Applying Django migrations...."
        pulp-manager makemigrations pulp_app
        pulp-manager migrate --noinput auth
        pulp-manager migrate --noinput
        pulp-manager reset-admin-password --password admin
    else
        echo "PostgreSQL database is not available. Bypassing Django migrations...."
    fi
fi

# delete $FIRST_RUN file
rm -f ${FIRST_RUN}

# call run.sh
exec /nightly/run.sh "$@"
