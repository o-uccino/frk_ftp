#!/bin/bash

if [ "$TEST_MODE" = "true" ]; then
    echo "test mode is true"
else
    echo "test mode is false"
    exit 1
fi

DATETIME=$(date '+%Y%m%d%H%M%S')
DATE=$(date '+%Y%m%d')

/home/frk_ftp/scripts/remove_work_images.sh
{
    echo "--- 画像削除 終了 --- ${DATETIME}"
} >> "/home/frk_ftp/scripts/testlog_${DATETIME}.log"

mkdir -p "/home/frk_ftp/agents/mitsubishiufj/"
mkdir -p "/home/frk_ftp/agents/mitsubishiufj/madori"
mkdir -p "/home/frk_ftp/agents/mitsubishiufj/photo"
mkdir -p "/home/frk_ftp/agents/mitsubishiufj/photo2"
mkdir -p "/home/frk_ftp/agents/mitsubishiufj/photo3"
mkdir -p "/home/frk_ftp/agents/mitsubishiufj/photo4"
mkdir -p "/home/frk_ftp/agents/mitsubishiufj/photo5"

touch "/home/frk_ftp/agents/mitsubishiufj/frk_chukai.csv"

{
    echo "1,52IK0156,20180629,1,1,1,5730,63.2,,,,26104,92902,6661,30,,8,,80,324,,,,5,5.4,,,1,1,,5,1,,,,東京都港区港南四丁目１番地,,181000,三井不動産販売港南Ｃ,0120-301-844,,,,1,,1,2,,,3,5,1,2,1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,018100052IK0156,三井不動産販売（株）港南センター,0120-301-844,,,,,,1,,,,,賃貸Ｙ型,,20250207,,,6591,60,,11,,,,,,,,,,1,,,,,,,,,,,,,,,,,,,,,,,,,20180629,20250328,賃貸,戸建,その他戸建,その他戸建,前面道路,その他,,,,,,,,,,,,,,,,"
    echo "1,53HK0347,20190202,1,1,1,2980,161,,,,28102,32002,6664,140,,18,,60,150,,,,4,1.8,,,3,1,,5,1,,,,兵庫県宝塚市中筋通２丁目,,181000,三井不動産販売宝塚Ｃ,0120-301-912,建物総合保険付,,,1,,1,2,,,3,1,1,2,1,,,3,1.6,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,018100053HK0347,三井不動産販売（株）宝塚センター,0120-301-912,,,,,,1,セットバック面積約２７㎡（約８．１６坪）含む。登記簿面積により、面積が異なる場合があります。,,,,山本高司,,20250207,,,,,,,,,,,,,,,,1,,,,,,,,,,,,,,,,,,,,,,,,,20190202,20250501,賃貸,戸建,その他戸建,その他戸建,前面道路,前面道路,,,,,,,,,,,,,,,,"
    echo "1,52JK0247,20200116,1,1,1,4900,154,,,,26101,47000,6591,10,16,3,,60,200,,,,1,11,1,,2,1,,5,1,,,,東京都港区北青山３丁目,,181000,三井不動産販売港南Ｃ,0120-301-844,建築確認申請中,,最寄停留所バス停１６分の立地ですが、朝夕時はバス停１５分,1,,1,2,,,3,2,1,2,1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,018100052JK0247,三井不動産販売（株）港南センター,0120-301-844,,,,,,1,「都市ガス」は本管引込済み、「上下水道」は本管引込予定（地域（北青山）,,,,山田太郎,,20250207,,,,,,,,,,,,,３丁目,,,1,,,,,,,,,,,,,,,,,,,,,,,,,20200116,20250415,賃貸,戸建,その他,その他,その他,その他,,,,,,,,,,,,,,,,"
    echo "1,730KS00K,20201110,1,1,1,1700,147.27,,,,23207,104005,4452,30,,7,,80,200,,,,3,24.3,1,,1,1,,5,1,,,,愛知県豊川市通５丁目,,181000,三井不動産販売名古屋駅前,0120-371-664,国府中学校まで約２７０ｍ,,国府小学校まで約２８０ｍ,1,,2,2,,,3,4,1,2,1,,6.3,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,0181000730KS00K,三井不動産販売（株）名古屋駅前センター,0120-371-664,,,,,,1,建物保険付,,,,山本太郎,,20250207,,,,,,,,,,,,,,,,1,,,,,,,,,,,,,,,,,,,,,,,,,20201110,20250509,賃貸,戸建,その他戸建,その他戸建,その他戸建,前面道路,,,,,,,,,,,,,,,,"
    echo "1,710KS0BL,20210129,1,1,1,500,165,,,,23213,197116,4455,30,,8,,60,200,,,,5,4.7,2,,3,1,,5,1,,,,愛知県豊田市高原町北田,,181000,三井不動産販売豊田支店,0120-371-386,学区まで１０分以内,,土地造成は必要,1,,1,2,,,3,6,1,2,1,,,1,2.6,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,0181000710KS0BL,三井不動産販売（株）豊田第１センター,0120-371-386,,,,,,1,セットバック面積約１５.２３坪必要、南側・西側未舗装、道路：北側幅員２.６５～３.７５ｍ、接道距離２２ｍ,,,,佐藤ドミニク,,20250207,,,,,,,,,,,,,,,,1,,,,,,,,,,,,,,,,,,,,,,,,,20210129,20250428,賃貸,戸建,その他戸建,その他戸建,その他戸建,その他戸建,,,,,,,,,,,,,,,,"
} | iconv -c -f UTF-8 -t SHIFT-JIS > "/home/frk_ftp/agents/mitsubishiufj/frk_chukai.csv.tmp" && \
mv "/home/frk_ftp/agents/mitsubishiufj/frk_chukai.csv.tmp" "/home/frk_ftp/agents/mitsubishiufj/frk_chukai.csv"

touch "/home/frk_ftp/agents/mitsubishiufj/madori/52IK0156.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/madori/53HK0347.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/madori/52JK0247.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/madori/730KS00K.jpg"

touch "/home/frk_ftp/agents/mitsubishiufj/photo/52IK0156.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/photo/53HK0347.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/photo/52JK0247.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/photo/730KS00K.jpg"

touch "/home/frk_ftp/agents/mitsubishiufj/photo2/52IK0156.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/photo2/53HK0347.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/photo2/52JK0247.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/photo2/730KS00K.jpg"

touch "/home/frk_ftp/agents/mitsubishiufj/photo3/52IK0156.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/photo3/53HK0347.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/photo3/52JK0247.jpg"

touch "/home/frk_ftp/agents/mitsubishiufj/photo4/52IK0156.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/photo4/53HK0347.jpg"

touch "/home/frk_ftp/agents/mitsubishiufj/photo5/52IK0156.jpg"

{
    echo "--- データ作成 終了 --- ${DATETIME}"
} >> "/home/frk_ftp/scripts/testlog_${DATETIME}.log"

/home/frk_ftp/scripts/upload_csv_to_s3.sh
{
    aws s3 ls "s3://recat-staging/estates_import/frk/${DATE}/"
    echo "--- CSVアップロード 終了 --- ${DATETIME}"
} >> "/home/frk_ftp/scripts/testlog_${DATETIME}.log"

/home/frk_ftp/scripts/upload_picture_avail_to_s3.sh
{
    cat "/home/frk_ftp/agents/mitsubishiufj/frk_bukken_check.csv"
    aws s3 ls "s3://recat-staging/estate_import/frk/${DATE}/"
    echo "--- 画像存在チェックアップロード 終了 --- ${DATETIME}"
} >> "/home/frk_ftp/scripts/testlog_${DATETIME}.log"

# correct data
cat > "/home/frk_ftp/agents/mitsubishiufj/correct_data.csv" << EOL
frk_bukken_id,madori,photo,photo2,photo3,photo4,photo5
52IK0156,true,true,true,true,true,true
52JK0247,true,true,true,true,false,false
53HK0347,true,true,true,true,true,false
710KS0BL,false,false,false,false,false,false
730KS00K,true,true,true,false,false,false
EOL

if diff -q "/home/frk_ftp/agents/mitsubishiufj/frk_bukken_check.csv" "/home/frk_ftp/agents/mitsubishiufj/correct_data.csv" > /dev/null; then
    echo "--- CSVファイル検証 OK --- ${DATETIME}" >> "/home/frk_ftp/scripts/testlog_${DATETIME}.log"
    echo "csv check ok"
else
    {
        echo "--- CSVファイル検証 NG --- ${DATETIME}"
        echo "--- 差分の詳細 --- ${DATETIME}"
        diff "/home/frk_ftp/agents/mitsubishiufj/frk_bukken_check.csv" "/home/frk_ftp/agents/mitsubishiufj/correct_data.csv"
    } >> "/home/frk_ftp/scripts/testlog_${DATETIME}.log"
    echo "csv check ng"
    diff "/home/frk_ftp/agents/mitsubishiufj/frk_bukken_check.csv" "/home/frk_ftp/agents/mitsubishiufj/correct_data.csv"
fi

echo "test end"
rm -rf "/home/frk_ftp/agents/mitsubishiufj/"
echo "clean up ok"
echo "--- clean up 終了 --- ${DATETIME}" >> "/home/frk_ftp/scripts/testlog_${DATETIME}.log"

echo "detail log: /home/frk_ftp/scripts/testlog_${DATETIME}.log"
exit 0
