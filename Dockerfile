FROM python:3-alpine

WORKDIR /usr/src/app
ADD . /usr/src/app

ENV DATAROOTDIR /usr/share
ENV SYSCONFDIR /etc
ENV AD_LOGIN administrator
ENV PASSWORD password

RUN apk add --no-cache bash libldap openldap-clients && \
    apk add --no-cache --virtual build-dependencies build-base yaml-dev openldap-dev && \
    pip3 install flup && \
    apk-add --no-cache 
    python setup.py install && \
    apk del build-dependencies && \
    cp -v conf/* /etc/ldapcherry && \
    adduser -S ldapcherry && \
    rm -rf /usr/src/app

USER ldapcherry
WORKDIR /home/ldapcherry

CMD [ "ldapcherryd", "-D", "-c", "/etc/ldapcherry/ldapcherry.ini"]
