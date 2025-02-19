#!/bin/bash

DATE=$(date +%Y-%m-%d\ %H:%M:%S)
BASE_DIR="/home/frk_ftp/works/agents"
OUTPUT_FILE_NAME="frk_bukken_check.csv"
OUTPUT_FILE_PATH="/home/frk_ftp/works/agents/mitsubishiufj/$OUTPUT_FILE_NAME"
LOG_FILE_SCRIPT="/home/frk_ftp/works/agents/mitsubishiufj/frk_bukken_check.log"
LOG_FILE_GENERAL="/home/frk_ftp/log/output.log"

# 出力ファイルのヘッダー作成
echo "frk_bukken_id,madori,photo,photo2,photo3,photo4,photo5" > "$OUTPUT_FILE"

# ファイルリストの各ファイル名に対して処理
while IFS= read -r filename; do
    frk_bukken_id="${filename%.*}"

    madori_exists=$([ -f "$BASE_DIR/madori/$filename" ] && echo "true" || echo "false")
    photo_exists=$([ -f "$BASE_DIR/photo/$filename" ] && echo "true" || echo "false")
    photo2_exists=$([ -f "$BASE_DIR/photo2/$filename" ] && echo "true" || echo "false")
    photo3_exists=$([ -f "$BASE_DIR/photo3/$filename" ] && echo "true" || echo "false")
    photo4_exists=$([ -f "$BASE_DIR/photo4/$filename" ] && echo "true" || echo "false")
    photo5_exists=$([ -f "$BASE_DIR/photo5/$filename" ] && echo "true" || echo "false")
    
    # 結果をCSVファイルに追記
    echo "$frk_bukken_id,$madori_exists,$photo_exists,$photo2_exists,$photo3_exists,$photo4_exists,$photo5_exists" >> "$OUTPUT_FILE_NAME"
done < "$OUTPUT_FILE_PATH"

if ! tail -n 1 "$OUTPUT_FILE_PATH" | grep -q "frk_bukken_id"; then
    echo "--- file check failed --- $DATE" > "$LOG_FILE_SCRIPT"
    echo "--- file check failed --- $DATE" >> "$LOG_FILE_GENERAL"
    exit 1
fi

echo "--- file check completed --- $DATE" > "$LOG_FILE_SCRIPT"
echo "--- file check completed --- $DATE" >> "$LOG_FILE_GENERAL"

if aws s3 cp "$OUTPUT_FILE" "s3:///recat-staging/estate_import/frk/$(date +%Y%m%d)/${OUTPUT_FILE}"; then
    echo "--- file upload completed --- $DATE" > "$LOG_FILE_SCRIPT"
    echo "--- file upload completed --- $DATE" >> "$LOG_FILE_GENERAL"
    exit 0
else
    echo "--- file upload failed --- $DATE" > "$LOG_FILE_SCRIPT"
    echo "--- file upload failed --- $DATE" >> "$LOG_FILE_GENERAL"
    exit 1
fi
