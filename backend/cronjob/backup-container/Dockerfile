FROM postgres:18-alpine

RUN apk add --no-cache bash busybox-suid

RUN mkdir -p /backups

COPY backup.sh /usr/local/bin/backup.sh
COPY crontab.txt /etc/crontabs/root

RUN chmod +x /usr/local/bin/backup.sh

CMD ["crond", "-f"]
