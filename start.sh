#!/bin/bash

while ! pg_isready -q -h $DBHOST -p $DBPORT -U $DBUSER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

/app/_build/prod/rel/club_backend/bin/club_backend eval ClubBackend.Release.migrate
/app/_build/prod/rel/club_backend/bin/club_backend start
