Backup container for elasticsearch data directory
_________________________________________________

This image provides a cron daemon that runs daily backups from elasticsearch data directory to Amazon S3.

Following ENV variables must be specified:

	ELASTICSEARCH_URL url with port where your elasticsearch runs, for example localhost:9200
    S3_URL contains address in S3 where to store backups
        bucket-name/directory
    S3_ACCESS_KEY
    S3_SECRET_KEY
    CRON_SCHEDULE cron schedule string, default '0 2 * * *'

Examples:

1) Run docker container with elasticsearch:

	docker run --name elasticsearch -v /var/backup/elasticsearch -p 9200:9200 -d elasticsearch -Des.path.repo=/var/backup/elasticsearch
2) And then run your elasticsearch-backup-to-s3 container:

	docker run --link elasticsearch:elasticsearch -e ELASTICSEARCH_URL="elasticsearch:9200" -e SNAPSHOT_VOLUME="/var/backup/elasticsearch" -e S3_URL="your S3 url" -e S3_ACCESS_KEY="your S3 access key" -e S3_SECRET_KEY="your S3 secret key"
