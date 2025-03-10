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
    echo "1,510NS004,20200119,1,1,1,14000,702.09,,372.12,,27203,45001,6668,110,,13,,60,150,9,7,,3,4,1,2025,1,1,,5,1,,,,大阪府豊中市清風荘１丁目,,181000,三菱ＵＦＪ不動産販売梅田第１,0120-301-142,●間取り：２ＬＤＫ（１Ｆ）＋５ＬＤＫ＋２納戸（２Ｆ）,,●１Ｆ、２Ｆ、それぞれに玄関あり,1,,2,2,,,3,1,1,,1,,,,,1,2,,,8,40,,,,,,,,,,,,,,,,,,,,,,1,,0181000510NS004,三菱ＵＦＪ不動産販売（株）梅田第１センター,0120-301-142,,,,,,1,●付属建物の表示：【種類】倉庫【構造】鉄筋コンクリート造陸屋根平家建【床面積】２７．５０m2,,,,新井勝信,,20250207,,,,,,,,,,,,,,,,1,,,,,,,,,,,,,,,,,,,,,,0,0,0,20200119,20250118,間取,外観,ダイニング,キッチン,リビング,廊下,,,,,,,,,,,,,,,,,"
    echo "1,390LK05L,20211028,1,1,1,1860,,,14.27,4.35,13104,95000,2199,240,,5,,,,1,1,,,,,2025,,,,5,1,,ガーデン鷹乃羽,8500,東京都新宿区若宮町,,181000,三菱ＵＦＪ不動産販売錦糸町Ｃ,0120-203-823,５路線利用可能,,■東南バルコニー　■管理形態：全部委託：巡回（週４日）月曜〜土曜（※ごみ収集日に合わせて勤務）／週４時間（※ごみ収集時間に合わせて勤務）,1,,2,2,,,3,5,1,,,,,,,4,5,,4,7,24,4,,,,,,,,,,,,,,,,,,,,,4,,0181000390LK05L,三菱ＵＦＪ不動産販売（株）錦糸町センター,0120-203-823,,,,,,1,東京メトロ南北線・有楽町線・東西線「飯田橋」駅徒歩３分、都営大江戸線「飯田橋」駅徒歩３分、「牛込神楽坂」駅徒歩７分,,7200,,中山正大,,20250207,,,2347,130,,3,,2358,260,,7,,,,,1,,,,,,,,,,,,,,,,,,,3,,,,,,20211028,20250427,間取,外観,室内の様子,室内の様子,収納,キッチン,,,,,,,,,,,,,,,,,1"
    echo "1,230MK05O,20221024,1,1,1,4980,224.33,,174.49,,14212,63002,2311,340,13,3,,50,100,9,4,,6,6,1,2025,1,1,,4,1,,,,神奈川県厚木市温水西２丁目,,181000,三菱ＵＦＪ不動産販売町田Ｃ,0120-203-499,,,,1,,1,2,,,3,1,1,,1,,,,,1,2,,,11,40,,,,,,,,,,,,,,,,,,,,,,1,,0181000230MK05O,三菱ＵＦＪ不動産販売（株）町田センター,0120-203-499,,,,,,1,※間取：４ＬＤＫ＋納戸×２＋ＷＩＣ※角地緩和により建ぺい率６０％,,,,河島浩彰,,20250207,,,,,,,,,,,,,毛利台一丁目,,,1,,,,,,,,,,,,,,,,,,,,,,0,0,0,20221024,20250423,間取,外観,その他外観,LD,LD,LD,,,,,,,,,,,,,,,,,"
    echo "1,310LK06C,20211206,1,1,1,3200,274.71,,238.22,,28204,309000,6605,105,7,9,,50,100,5,6,,1,4.6,1,2025,1,1,,5,1,,,,兵庫県西宮市名塩山荘,,181000,三菱ＵＦＪ不動産販売大阪中央,0120-301-574,,,,1,,2,2,,,3,1,1,,1,,16.2,,,1,3,,,8,40,,,,,,,,,,,,,,,,,,,,,,4,,0181000310LK06C,三菱ＵＦＪ不動産販売（株）大阪中央センター,0120-301-574,,,,,,1,,,,,池田浩介,,20250207,,,,,,,,,,,,,名塩山荘,,,1,,,,,,,,,,,,,,,,,,,,,,0,0,0,20211206,20250305,間取,外観,LD,LD,キッチン,玄関,,,,,,,,,,,,,,,,,"
    echo "1,510MK04P,20220607,1,1,1,7980,288.05,,263.8,,27203,30005,6709,90,,4,,60,150,9,9,,4,3.6,,2025,1,1,,5,1,,,,大阪府豊中市柴原町５丁目,,181000,三菱ＵＦＪ不動産販売梅田第１,0120-301-142,間取り：９ＬＤＫ＋ＬＤＫ＋納戸,,建築基準法第２２条区域,1,,1,2,,,3,1,1,,1,,,1,2.8,1,2,,,11,40,,,,,,,,,,,,,,,,,,,,,,8,,0181000510MK04P,三菱ＵＦＪ不動産販売（株）梅田第１センター,0120-301-142,,,,,,1,絶対高さ１０ｍ・埋蔵文化財包蔵地（桜井谷窯跡群）・駐車場４台可（車種による制限あり）,,,,上出麻人,,20250207,,,,,,,,,,,,,,,,1,,,,,,,,,,,,,,,,,,,,,,0,0,0,20220607,20250306,間取,外観,その他外観,その他外観,その他外観,その他外観,,,,,,,,,,,,,,,,,"
} | iconv -c -f UTF-8 -t SHIFT-JIS > "/home/frk_ftp/agents/mitsubishiufj/frk_chukai.csv.tmp" && \

mv "/home/frk_ftp/agents/mitsubishiufj/frk_chukai.csv.tmp" "/home/frk_ftp/agents/mitsubishiufj/frk_chukai.csv"

touch "/home/frk_ftp/agents/mitsubishiufj/madori/510NS004.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/madori/390LK05L.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/madori/230MK05O.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/madori/310LK06C.jpg"

touch "/home/frk_ftp/agents/mitsubishiufj/photo/510NS004.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/photo/390LK05L.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/photo/230MK05O.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/photo/310LK06C.jpg"

touch "/home/frk_ftp/agents/mitsubishiufj/photo2/510NS004.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/photo2/390LK05L.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/photo2/230MK05O.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/photo2/310LK06C.jpg"

touch "/home/frk_ftp/agents/mitsubishiufj/photo3/510NS004.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/photo3/390LK05L.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/photo3/230MK05O.jpg"

touch "/home/frk_ftp/agents/mitsubishiufj/photo4/510NS004.jpg"
touch "/home/frk_ftp/agents/mitsubishiufj/photo4/390LK05L.jpg"

touch "/home/frk_ftp/agents/mitsubishiufj/photo5/510NS004.jpg"

{
    echo "--- データ作成 終了 --- ${DATETIME}"
} >> "/home/frk_ftp/scripts/testlog_${DATETIME}.log"
/home/frk_ftp/scripts/copy_data_to_work_directory.sh

/home/frk_ftp/scripts/upload_csv_to_s3.sh
{
    aws s3 ls "s3://recat-staging/estates_import/frk/${DATE}/"
    echo "--- CSVアップロード 終了 --- ${DATETIME}"
} >> "/home/frk_ftp/scripts/testlog_${DATETIME}.log"

/home/frk_ftp/scripts/upload_picture_avail_to_s3.sh
{
    cat "/home/frk_ftp/works/agents/mitsubishiufj/frk_bukken_check.csv"
    aws s3 ls "s3://recat-staging/estate_import/frk/${DATE}/"
    echo "--- 画像存在チェックアップロード 終了 --- ${DATETIME}"
} >> "/home/frk_ftp/scripts/testlog_${DATETIME}.log"

# correct data
cat > "/home/frk_ftp/works/agents/mitsubishiufj/correct_data.csv" << EOL
frk_bukken_id,madori,photo,photo2,photo3,photo4,photo5
510NS004,true,true,true,true,true,true
390LK05L,true,true,true,true,true,false
230MK05O,true,true,true,true,false,false
310LK06C,true,true,true,false,false,false
510MK04P,false,false,false,false,false,false
EOL

if diff -q "/home/frk_ftp/works/agents/mitsubishiufj/frk_bukken_check.csv" "/home/frk_ftp/works/agents/mitsubishiufj/correct_data.csv" > /dev/null; then
    echo "--- CSVファイル検証 OK --- ${DATETIME}" >> "/home/frk_ftp/scripts/testlog_${DATETIME}.log"
    echo "csv check ok"
else
    {
        echo "--- CSVファイル検証 NG --- ${DATETIME}"
        echo "--- 差分の詳細 --- ${DATETIME}"
        diff "/home/frk_ftp/works/agents/mitsubishiufj/frk_bukken_check.csv" "/home/frk_ftp/works/agents/mitsubishiufj/correct_data.csv"
    } >> "/home/frk_ftp/scripts/testlog_${DATETIME}.log"
    echo "csv check ng"
    diff "/home/frk_ftp/works/agents/mitsubishiufj/frk_bukken_check.csv" "/home/frk_ftp/works/agents/mitsubishiufj/correct_data.csv"
fi

echo "test end"
rm -rf "/home/frk_ftp/works/agents/mitsubishiufj/"
echo "clean up ok"
echo "--- clean up 終了 --- ${DATETIME}" >> "/home/frk_ftp/scripts/testlog_${DATETIME}.log"

echo "detail log: /home/frk_ftp/scripts/testlog_${DATETIME}.log"
exit 0
