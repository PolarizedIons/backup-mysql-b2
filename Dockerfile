FROM alpine

# mysqldump
RUN apk add --no-cache mysql-client

# b2
RUN apk update \
    && apk add git python3 \
    && python3 -m ensurepip \
    && python3 -m pip install --upgrade pip \
    && pip3 install --no-cache-dir b2

ENV B2_USER=
ENV B2_KEY=
ENV B2_BUCKET=

ENV DB_HOST=
ENV DB_USER=
ENV DB_PASS=

COPY backup-and-upload.sh /

CMD '/backup-and-upload.sh'
