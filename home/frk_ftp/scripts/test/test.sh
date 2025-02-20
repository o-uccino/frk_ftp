#!/bin/bash

if [ "$TEST_MODE" = "true" ]; then
    echo "test mode is true"
else
    echo "test mode is false"
    exit 1
fi

DATETIME=$(date '+%Y%m%d%H%M%S')
DATE=$(date '+%Y%m%d')

./remove_work_images.sh
{
    ls "/home/frk_ftp/agents/mitsubishiufj/"
    echo "--- 画像削除 終了 --- ${DATETIME}"
} >> "/home/frk_ftp/scripts/testlog_${DATETIME}.log"

mkdir -p "/home/frk_ftp/agents/mitsubishiufj/"
mkdir -p "/home/frk_ftp/agents/mitsubishiufj/madori"
mkdir -p "/home/frk_ftp/agents/mitsubishiufj/photo"
mkdir -p "/home/frk_ftp/agents/mitsubishiufj/photo2"
mkdir -p "/home/frk_ftp/agents/mitsubishiufj/photo3"
mkdir -p "/home/frk_ftp/agents/mitsubishiufj/photo4"
mkdir -p "/home/frk_ftp/agents/mitsubishiufj/photo5"

touch "/home/frk_ftp/agents/mitsubishiufj/madori/12345678.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/madori/12345679.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/madori/12345680.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/madori/12345681.jpg"

touch "/home/frk_ftp/agents/mitsubishiufj/photo/12345678.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/photo/12345679.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/photo/12345680.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/photo/12345681.jpg"

touch "/home/frk_ftp/agents/mitsubishiufj/photo2/12345678.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/photo2/12345679.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/photo2/12345680.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/photo2/12345681.jpg"

touch "/home/frk_ftp/agents/mitsubishiufj/photo3/12345678.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/photo3/12345679.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/photo3/12345680.jpg"

touch "/home/frk_ftp/agents/mitsubishiufj/photo4/12345678.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/photo4/12345679.jpg"

touch "/home/frk_ftp/agents/mitsubishiufj/photo5/12345678.jpg"

{
    echo "--- データ作成 終了 --- ${DATETIME}"
} >> "/home/frk_ftp/scripts/testlog_${DATETIME}.log"

./upload_csv_to_s3.sh
{
    aws s3 ls "s3://recat-staging/estates_import/frk/${DATE}/"
    echo "--- CSVアップロード 終了 --- ${DATETIME}"
} >> "/home/frk_ftp/scripts/testlog_${DATETIME}.log"

./upload_picture_avail_to_s3.sh
{
    cat "/home/frk_ftp/agents/mitsubishiufj/frk_bukken_check.csv"
    aws s3 ls "s3://recat-staging/estate_import/frk/${DATE}/"
    echo "--- 画像存在チェックアップロード 終了 --- ${DATETIME}"
} >> "/home/frk_ftp/scripts/testlog_${DATETIME}.log"

echo "test ok"
rm -rf "/home/frk_ftp/agents/mitsubishiufj/"
echo "clean up ok"

echo "--- clean up 終了 --- ${DATETIME}" >> "/home/frk_ftp/scripts/testlog_${DATETIME}.log"
exit 0
