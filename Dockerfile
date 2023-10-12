FROM alt:sisyphus

# TODO 
# 1. Добавить подключаемый кеш пакетов-зеркала https://www.altlinux.org/Hasher/Tips#Кэширование_скачиваемых_apt-ом_пакетов"

# Юзер для сборки
RUN adduser buildovich

# Установка необходимых пакетов, hasher и настройка
RUN apt-get update && \
    apt-get install -y su git etersoft-build-utils hasher gear sisyphus_check rpm-build qa-robot

USER buildovich
ENV HOME /home/buildovich
WORKDIR /home/buildovich

RUN mkdir /home/buildovich/hasher

RUN git config --global user.email ci@build.org
RUN git config --global user.name "CI Buildovich"

RUN mkdir -p /home/buildovich/RPM/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

ARG APP=neofetch

# Сборка
COPY ./${APP} /home/buildovich/${APP}

RUN git config --global --add safe.directory /home/buildovich/${APP}
RUN cd ${APP} && gear-rpm -ba
# RUN cd ${APP} && gear-hsh
