#!/bin/bash

source /home/frk_ftp/scripts/environment

DATE=$(date +%Y-%m-%d\ %H:%M:%S)
BASE_DIR="/home/frk_ftp/works/"
LOG_FILE_GENERAL="/home/frk_ftp/log/output.log"
FOLDER_LIST_FILE="/home/frk_ftp/scripts/config/target_folders"
# 権限のあるS3バケットパスに変更

S3_BUCKET="s3://${RECAT_S3_BUCKET}/estates_import/frk/$(date +%Y%m%d)"

# フォルダリストファイルが存在するか確認
if [ ! -f "$FOLDER_LIST_FILE" ]; then
    echo "ERROR: Folder list file not found: $FOLDER_LIST_FILE" >> "$LOG_FILE_GENERAL"
    exit 1
fi

# 各フォルダに対して処理を実行
while IFS= read -r FOLDER || [ -n "$FOLDER" ]; do
    # コメント行やトリム
    FOLDER=$(echo "$FOLDER" | sed 's/#.*//g' | xargs)
    [ -z "$FOLDER" ] && continue

    echo "Processing folder: $FOLDER" >> "$LOG_FILE_GENERAL"

    # フォルダが存在するか確認
    if [ ! -d "$BASE_DIR/$FOLDER" ]; then
        echo "--- Folder not found: $FOLDER --- $DATE" >> "$LOG_FILE_GENERAL"
        continue
    fi

    OUTPUT_FILE_NAME="frk_bukken_check.csv"
    OUTPUT_FILE_PATH="$BASE_DIR/$FOLDER/$OUTPUT_FILE_NAME"
    LOG_FILE_SCRIPT="/home/frk_ftp/log/$FOLDER/frk_bukken_check.log"

    # ログディレクトリがない場合は作成
    mkdir -p "/home/frk_ftp/log/$FOLDER"

    # 出力ファイルのヘッダー作成
    touch "$OUTPUT_FILE_PATH"
    echo "frk_bukken_id,madori,photo,photo2,photo3,photo4,photo5" > "$OUTPUT_FILE_PATH"

    # XMLファイルが存在するか確認（CSVとXMLの両方をサポート）
    XML_INPUT_FILE="$BASE_DIR/$FOLDER/bukken.xml"
    CSV_INPUT_FILE="$BASE_DIR/$FOLDER/bukken.csv"
    
    if [ -f "$XML_INPUT_FILE" ]; then
        echo "--- Processing XML input file: $XML_INPUT_FILE --- $DATE" >> "$LOG_FILE_GENERAL"
        # XMLファイルから物件番号を抽出 (property_number)
        xmllint --xpath "//lineItem/property/basic/property_number/text()" "$XML_INPUT_FILE" 2>/dev/null | tr ' ' '\n' | grep -v '^$' | while read property_number; do
            # 物件番号の最後の8桁を抽出（CSVと同じロジック）
            echo "${property_number: -8}"
        done | sort -u > "/tmp/${FOLDER}_bukken_list.txt"
        
        # xmllintが利用できない場合の代替手段
        if [ ! -s "/tmp/${FOLDER}_bukken_list.txt" ]; then
            echo "--- xmllint not available, using grep for XML parsing --- $DATE" >> "$LOG_FILE_GENERAL"
            grep -o '<property_number>[^<]*</property_number>' "$XML_INPUT_FILE" | sed 's/<[^>]*>//g' | while read property_number; do
                # 物件番号の最後の8桁を抽出（CSVと同じロジック）
                echo "${property_number: -8}"
            done | sort -u > "/tmp/${FOLDER}_bukken_list.txt"
        fi
    elif [ -f "$CSV_INPUT_FILE" ]; then
        echo "--- Processing CSV input file: $CSV_INPUT_FILE --- $DATE" >> "$LOG_FILE_GENERAL"
        # CSVファイルから物件IDを抽出 - エラー対策としてエラーを無視するオプションを追加
        iconv -f SHIFT-JIS -t UTF-8 -c "$CSV_INPUT_FILE" > "/tmp/${FOLDER}_utf8.csv" || true
        if [ ! -s "/tmp/${FOLDER}_utf8.csv" ]; then
            echo "--- iconv failed for $FOLDER/bukken.csv, trying with --unicode-subst option --- $DATE" >> "$LOG_FILE_GENERAL"
            iconv -f SHIFT-JIS -t UTF-8 --unicode-subst="?" "$CSV_INPUT_FILE" > "/tmp/${FOLDER}_utf8.csv" || true
        fi
        awk -F',' '{val=$88; gsub(/^"|"$/, "", val); print substr(val, 8, 8)}' "/tmp/${FOLDER}_utf8.csv" | sort -u > "/tmp/${FOLDER}_bukken_list.txt"
    else
        echo "--- Neither bukken.xml nor bukken.csv found in $FOLDER --- $DATE" >> "$LOG_FILE_GENERAL"
        continue
    fi

    # ファイルリストの各ファイル名に対して処理
    while IFS= read -r property_number; do
        # ダブルクオーテーションを削除
        property_number=$(echo "$property_number" | tr -d '"')
        
        # 8桁未満の場合に0埋めする処理
        property_number_length=${#property_number}
        if [ "$property_number_length" -lt 8 ]; then
            # 0埋めして8桁にする
            property_number=$(printf "%08d" "$property_number")
            echo "ID padded to 8 digits: $property_number" >> "$LOG_FILE_SCRIPT"
        fi
        
        madori_exists=$([ -f "$BASE_DIR/$FOLDER/madori/$property_number.jpg" ] && echo "true" || echo "false")
        photo_exists=$([ -f "$BASE_DIR/$FOLDER/photo/$property_number.jpg" ] && echo "true" || echo "false")
        photo2_exists=$([ -f "$BASE_DIR/$FOLDER/photo2/$property_number.jpg" ] && echo "true" || echo "false")
        photo3_exists=$([ -f "$BASE_DIR/$FOLDER/photo3/$property_number.jpg" ] && echo "true" || echo "false")
        photo4_exists=$([ -f "$BASE_DIR/$FOLDER/photo4/$property_number.jpg" ] && echo "true" || echo "false")
        photo5_exists=$([ -f "$BASE_DIR/$FOLDER/photo5/$property_number.jpg" ] && echo "true" || echo "false")
        # 結果をCSVファイルに追記
        echo "$property_number,$madori_exists,$photo_exists,$photo2_exists,$photo3_exists,$photo4_exists,$photo5_exists" >> "$OUTPUT_FILE_PATH"
    done < "/tmp/${FOLDER}_bukken_list.txt"

    # 一時ファイルの削除
    rm -f "/tmp/${FOLDER}_utf8.csv" "/tmp/${FOLDER}_bukken_list.txt"

    echo "--- file check completed for $FOLDER --- $DATE" > "$LOG_FILE_SCRIPT"
    echo "--- file check completed for $FOLDER --- $DATE" >> "$LOG_FILE_GENERAL"

    cat "$OUTPUT_FILE_PATH"

    # S3にアップロード - 修正したバケットパスを使用
    if aws s3 cp "$OUTPUT_FILE_PATH" "${S3_BUCKET}/${FOLDER}/${OUTPUT_FILE_NAME}"; then
        echo "--- file upload completed for $FOLDER --- $DATE" > "$LOG_FILE_SCRIPT"
        echo "--- file upload completed for $FOLDER --- $DATE" >> "$LOG_FILE_GENERAL"
    else
        echo "--- file upload failed for $FOLDER --- $DATE" > "$LOG_FILE_SCRIPT"
        echo "--- file upload failed for $FOLDER --- $DATE" >> "$LOG_FILE_GENERAL"
        # アップロード失敗時に詳細なエラー情報を取得
        aws s3 cp "$OUTPUT_FILE_PATH" "${S3_BUCKET}/${FOLDER}/${OUTPUT_FILE_NAME}" --debug >> "$LOG_FILE_SCRIPT" 2>&1
    fi
done < "$FOLDER_LIST_FILE"

exit 0

