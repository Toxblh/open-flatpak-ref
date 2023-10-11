FROM alt:sisyphus

# TODO 
# 1. Добавить подключаемый кеш пакетов-зеркала https://www.altlinux.org/Hasher/Tips#Кэширование_скачиваемых_apt-ом_пакетов"

# Юзер для сборки
RUN adduser buildovich

# Установка необходимых пакетов, hasher и настройка
RUN apt-get update && \
    apt-get install -y systemd su git etersoft-build-utils hasher gear sisyphus_check rpm-build qa-robot builder-useradd mkimage
# RUN apt-get install -y git hasher gear sisyphus_check rpm-build qa-robot

# Настройка hasher
# RUN systemctl enable --now hasher-privd.service
# RUN hasher-useradd buildovich
RUN builder-useradd buildovich


# RUN useradd rpmbuild -u 5002 -g users -p rpmbuild

USER buildovich
ENV HOME /home/buildovich
WORKDIR /home/buildovich

RUN mkdir /home/buildovich/hasher

RUN git config --global user.email ci@build.org
RUN git config --global user.name "CI Buildovich"

RUN mkdir -p /home/buildovich/RPM/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
# RUN echo '%_topdir %{getenv:HOME}/buildovich' > /home/buildovich/.rpmmacros

ARG APP=neofetch

# Сборка
COPY ./${APP} /home/buildovich/${APP}

RUN git config --global --add safe.directory /home/buildovich/${APP}
# RUN cd ${APP} && gear-rpm -ba
# RUN cd ${APP} && gear-hsh


RUN git clone https://gitlab.eterfund.ru/ximper/mkimage-profiles.git 
RUN cd mkimage-profiles && make grub.iso