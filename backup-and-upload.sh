#!/bin/sh

NOW=$(date +'%d-%m-%Y %H:%M:%S')
echo "[-] starting backup process at $NOW"

if [[ -z "$DB_USER" ]]; then
    echo "DB_USER is empty";
    exit 1;
fi

if [[ -z "$DB_PASS" ]]; then
    echo "DB_PASS is empty";
    exit 1;
fi

if [[ -z "$DB_HOST" ]]; then
    echo "DB_HOST is empty";
    exit 1;
fi

if [[ -z "$B2_USER" ]]; then
    echo "B2_USER is empty";
    exit 1;
fi

if [[ -z "$B2_KEY" ]]; then
    echo "B2_KEY is empty";
    exit 1;
fi
if [[ -z "$B2_BUCKET_NAME" ]]; then
    echo "B2_BUCKET_NAME is empty";
    exit 1;
fi

echo "[+] running mysqldump"
mysqldump -u$DB_USER -p$DB_PASS -h$DB_HOST --all-databases | gzip -c > /tmp/backup.gz

echo "[+] running b2 authorize"
b2 authorize-account $B2_USER $B2_KEY

echo "[+] running b2 upload"
b2 upload_file $B2_BUCKET_NAME "/tmp/backup.gz" "mysql-$NOW.gz"

echo "[-] done at $(date +'%d-%m-%Y %H:%M:%S')"
