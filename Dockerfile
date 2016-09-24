FROM debian:jessie


# entrypoint
COPY entrypoint.sh /entrypoint.sh

# backups to Amazon S3
RUN apt-get update && apt-get install -y s3cmd && apt-get install -y cron && rm -rf /var/lib/apt/lists/*
COPY s3cfg /root/.s3cfg

ENTRYPOINT ["/entrypoint.sh"]

CMD ["cron","-f"]
