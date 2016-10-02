#!/bin/bash
set -eo pipefail


#dependencies: curl

#docker run --name elasticsearch -v /var/backup/elasticsearch -p 9200:9200 -d elasticsearch -Des.path.repo=/var/backup/elasticsearch

SNAPSHOT_VOLUME=$1

SNAPSHOT_REPOSITORY_NAME=${SNAPSHOT_REPOSITORY_NAME-"elasticsearch-snapshots"}
SNAPSHOT_VOLUME=${SNAPSHOT_VOLUME-"/var/backup/elasticsearch"}
SNAPSHOT_NAME=${SNAPSHOT_NAME-"elasticsearch_$(date +%Y.%m.%d_%H:%M:%S)"}
ELASTICSEARCH_URL=${ELASTICSEARCH_URL-"localhost:9200"}



#check if elasticsearch url is online
while [[ -z "$(curl -s "http://${ELASTICSEARCH_URL}/" | grep "\"name\"")" ]]; do
	echo "${ELASTICSEARCH_URL} seems to be down"
	sleep 1;
done


#Without these 2 lines, this error when registering new snapshot repository occurs:
#    "type" : "repository_exception",
#    "reason" : "[backup00] failed to create repository",
#     "type" : "access_denied_exception",
mkdir -p "${SNAPSHOT_VOLUME}/${SNAPSHOT_REPOSITORY_NAME}"
chmod -R 777 "${SNAPSHOT_VOLUME}/${SNAPSHOT_REPOSITORY_NAME}"


#if snapshot repository don't exist, create it
result="$(curl "http://${ELASTICSEARCH_URL}/_snapshot/")"
if [[ -z "$(echo "result" | grep "$SNAPSHOT_REPOSITORY_NAME")" ]]; then
	curl -XPUT "http://${ELASTICSEARCH_URL}/_snapshot/${SNAPSHOT_REPOSITORY_NAME}?pretty" -d "
{
  \"type\" : \"fs\",
   \"settings\" : {
     \"compress\" : \"true\",
     \"location\" : \"/${SNAPSHOT_VOLUME}/${SNAPSHOT_REPOSITORY_NAME}\"
   }
}
"
fi
	
#create snaphot!
curl -XPUT "http://${ELASTICSEARCH_URL}/_snapshot/${SNAPSHOT_REPOSITORY_NAME}/${SNAPSHOT_NAME}?wait_for_completion=true"



return 0;











