# navitia2-docker-compose

This is a setup for a docker environment with a running Navitia 2.

## Requirements

* You need to have docker-compose installed
* The use of this environment suppose the use of docker-gen-hosts or equivalent.

## Features

This environment has 2 kraken instances (fr-cen and jdr) configured.

To use it, place the binarized data in `data/<instance>/` and start using 

```
docker-compose up -d
```

Jormungandr will be available at `http://navitia2-ws.local.canaltp.fr`
Tyr API will be available at `http://tyr.local.canaltp.fr`

## Caveats / Todos

* No Tyr worker is currently launched
* The instances are public (no authentication required)
