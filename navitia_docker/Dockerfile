FROM debian:wheezy

MAINTAINER Vincent Lepot <vincent.lepot@kisio.org>

ARG navitia_version

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install wget && \
    echo 'deb http://apt.canaltp.local/debian/repositories wheezy-production main non-free' > /etc/apt/sources.list.d/canaltp.list && \
    wget --output-document=- http://apt.canaltp.local/debian/repositories/canaltp.gpg.key | apt-key add - && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install \
        liblog4cplus-1.0-4 \
        libboost-thread1.49.0 libboost-date-time1.49.0 libboost-serialization1.49.0 libboost-regex1.49.0 libboost-chrono1.49.0 \
        libboost-test1.49.0 libboost-filesystem1.49.0 libboost-system1.49.0 libboost-program-options1.49.0 \
        libprotobuf9 \
        libpqxx-3.1 \
        libzmq1 \
        libproj0 \
        libgoogle-perftools4 \
        osmpbf-bin \
        libgeos-c1 \
        python-pip \
        && \
    rm -rf /var/lib/apt/lists/*

RUN set -xe && \
    mkdir -p /srv && \
    buildDeps="git" && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install $buildDeps && \
    git clone https://github.com/CanalTP/navitia /srv/navitia && \
    cd /srv/navitia && \
    git checkout v$navitia_version && \
    sed -i -e 's/git@github.com:/https:\/\/github.com\//g' .gitmodules && \
    git submodule update --init && \
    find . -type d -name '.git' -prune -exec rm -rf {} \; && \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $buildDeps && \
    rm -rf /var/lib/apt/lists/*

RUN set -xe && \
    buildDeps=" \
        git \
        g++ cmake liblog4cplus-dev libzmq-dev libosmpbf-dev libboost-all-dev libpqxx3-dev libgoogle-perftools-dev libprotobuf-dev libproj-dev protobuf-compiler \
        build-essential \
        " && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install $buildDeps && \
    pip install -r /srv/navitia/source/jormungandr/requirements.txt && \
    pip install -r /srv/navitia/source/tyr/requirements.txt && \
    mkdir -p /srv/navitia/bin/release && \
    cd /srv/navitia/bin/release && \
    cmake -DCMAKE_BUILD_TYPE=Release ../../source && \
    make -j4 && \
    mv /srv/navitia/bin/release/kraken/kraken /srv/navitia/bin/release/ed/*2ed /srv/navitia/bin/release/ed/*2nav /srv/navitia/bin/ && \
    make clean && \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $buildDeps && \
    rm -rf /var/lib/apt/lists/*

ADD jdr.json /etc/jormungandr.d/jdr.json
ADD kraken.ini /srv/navitia/run/kraken.ini

RUN sed -e 's/^DISABLE_DATABASE.*/DISABLE_DATABASE=True/' \
        -e "s/^BROKER_URL.*/BROKER_URL = 'amqp:\/\/guest:guest@rabbitmq:5672\/\/'/" \
        -e "s/^SQLALCHEMY_DATABASE_URI.*/SQLALCHEMY_DATABASE_URI = 'postgresql:\/\/navitia:navitia@database\/jormungandr'/" \
        "/srv/navitia/source/jormungandr/jormungandr/default_settings.py" > "/srv/navitia/run/jormungandr_settings.py"

VOLUME /srv/data
