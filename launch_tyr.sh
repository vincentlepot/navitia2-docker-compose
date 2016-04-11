#!/bin/bash

set -e

if [ ! -x /bin/nc ]; then
  apt-get update && apt-get -yq install netcat
fi

until nc -z database 5432
do
    echo "waiting for postgres container..."
    sleep 0.5
done

PYTHONPATH=/srv/navitia/source/tyr:/srv/navitia/source/navitiacommon TYR_CONFIG_FILE=/srv/navitia/run/tyr_settings.py python "/srv/navitia/source/tyr/manage_tyr.py" db upgrade

TYR_CONFIG_FILE="/srv/navitia/run/tyr_settings.py" PYTHONPATH="/srv/navitia/source/navitiacommon:/srv/navitia/source/tyr" python "/srv/navitia/source/tyr/manage_tyr.py" runserver -r -t 0.0.0.0 -p 80
