Backup container for elasticsearch data directory
_________________________________________________

This image provides a cron daemon that runs daily backups from elasticsearch data directory to Amazon S3.

Following ENV variables must be specified:

    S3_URL contains address in S3 where to store backups
        bucket-name/directory
    S3_ACCESS_KEY
    S3_SECRET_KEY
    CRON_SCHEDULE cron schedule string, default '0 2 * * *'
