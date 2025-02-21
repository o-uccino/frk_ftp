#!/bin/bash

DATE=$(date +%Y-%m-%d\ %H:%M:%S)
BASE_DIR="/home/frk_ftp/works/agents"
OUTPUT_FILE_NAME="frk_bukken_check.csv"
OUTPUT_FILE_PATH="$BASE_DIR/mitsubishiufj/$OUTPUT_FILE_NAME"
LOG_FILE_SCRIPT="/home/frk_ftp/log/mitsubishiufj/frk_bukken_check.log"
LOG_FILE_GENERAL="/home/frk_ftp/log/output.log"

# 出力ファイルのヘッダー作成
touch "$OUTPUT_FILE_PATH"
echo "frk_bukken_id,madori,photo,photo2,photo3,photo4,photo5" > "$OUTPUT_FILE_PATH"

# CSVファイルから物件IDを抽出
iconv -f SHIFT-JIS -t UTF-8 "$BASE_DIR/mitsubishiufj/frk_chukai.csv" > /tmp/frk_chukai_utf8.csv
awk -F',' '{print $2}' "/tmp/frk_chukai_utf8.csv" | sort -u > /tmp/bukken_list.txt

# ファイルリストの各ファイル名に対して処理
while IFS= read -r frk_bukken_id; do
    madori_exists=$([ -f "$BASE_DIR/mitsubishiufj/madori/$frk_bukken_id.jpg" ] && echo "true" || echo "false")
    photo_exists=$([ -f "$BASE_DIR/mitsubishiufj/photo/$frk_bukken_id.jpg" ] && echo "true" || echo "false")
    photo2_exists=$([ -f "$BASE_DIR/mitsubishiufj/photo2/$frk_bukken_id.jpg" ] && echo "true" || echo "false")
    photo3_exists=$([ -f "$BASE_DIR/mitsubishiufj/photo3/$frk_bukken_id.jpg" ] && echo "true" || echo "false")
    photo4_exists=$([ -f "$BASE_DIR/mitsubishiufj/photo4/$frk_bukken_id.jpg" ] && echo "true" || echo "false")
    photo5_exists=$([ -f "$BASE_DIR/mitsubishiufj/photo5/$frk_bukken_id.jpg" ] && echo "true" || echo "false")
    
    # 結果をCSVファイルに追記
    echo "$frk_bukken_id,$madori_exists,$photo_exists,$photo2_exists,$photo3_exists,$photo4_exists,$photo5_exists" >> "$OUTPUT_FILE_PATH"
done < /tmp/bukken_list.txt

# 一時ファイルの削除
rm /tmp/bukken_list.txt

echo "--- file check completed --- $DATE" > "$LOG_FILE_SCRIPT"
echo "--- file check completed --- $DATE" >> "$LOG_FILE_GENERAL"

cat $OUTPUT_FILE_PATH

if aws s3 cp "$OUTPUT_FILE_PATH" "s3://recat-staging/estates_import/frk/$(date +%Y%m%d)/mitsubishiufj/${OUTPUT_FILE_NAME}"; then
    echo "--- file upload completed --- $DATE" > "$LOG_FILE_SCRIPT"
    echo "--- file upload completed --- $DATE" >> "$LOG_FILE_GENERAL"
    exit 0
else
    echo "--- file upload failed --- $DATE" > "$LOG_FILE_SCRIPT"
    echo "--- file upload failed --- $DATE" >> "$LOG_FILE_GENERAL"
    exit 1
fi

