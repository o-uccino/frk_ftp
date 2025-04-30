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

    # CSVファイルが存在するか確認
    if [ ! -f "$BASE_DIR/$FOLDER/bukken.csv" ]; then
        echo "--- bukken.csv not found in $FOLDER --- $DATE" >> "$LOG_FILE_GENERAL"
        continue
    fi

    # CSVファイルから物件IDを抽出 - エラー対策としてエラーを無視するオプションを追加
    iconv -f SHIFT-JIS -t UTF-8 -c "$BASE_DIR/$FOLDER/bukken.csv" > "/tmp/${FOLDER}_utf8.csv" || true
    if [ ! -s "/tmp/${FOLDER}_utf8.csv" ]; then
        echo "--- iconv failed for $FOLDER/bukken.csv, trying with --unicode-subst option --- $DATE" >> "$LOG_FILE_GENERAL"
        iconv -f SHIFT-JIS -t UTF-8 --unicode-subst="?" "$BASE_DIR/$FOLDER/bukken.csv" > "/tmp/${FOLDER}_utf8.csv" || true
    fi

    awk -F',' '{print $2}' "/tmp/${FOLDER}_utf8.csv" | sort -u > "/tmp/${FOLDER}_bukken_list.txt"

    # ファイルリストの各ファイル名に対して処理
    while IFS= read -r frk_bukken_id; do
        # ダブルクオーテーションを削除
        frk_bukken_id=$(echo "$frk_bukken_id" | tr -d '"')
        
        # 8桁未満の場合に0埋めする処理
        frk_bukken_id_length=${#frk_bukken_id}
        if [ $frk_bukken_id_length -lt 8 ]; then
            # 0埋めして8桁にする
            frk_bukken_id=$(printf "%08d" $frk_bukken_id)
            echo "ID padded to 8 digits: $frk_bukken_id" >> "$LOG_FILE_SCRIPT"
        fi
        
        madori_exists=$([ -f "$BASE_DIR/$FOLDER/madori/$frk_bukken_id.jpg" ] && echo "true" || echo "false")
        photo_exists=$([ -f "$BASE_DIR/$FOLDER/photo/$frk_bukken_id.jpg" ] && echo "true" || echo "false")
        photo2_exists=$([ -f "$BASE_DIR/$FOLDER/photo2/$frk_bukken_id.jpg" ] && echo "true" || echo "false")
        photo3_exists=$([ -f "$BASE_DIR/$FOLDER/photo3/$frk_bukken_id.jpg" ] && echo "true" || echo "false")
        photo4_exists=$([ -f "$BASE_DIR/$FOLDER/photo4/$frk_bukken_id.jpg" ] && echo "true" || echo "false")
        photo5_exists=$([ -f "$BASE_DIR/$FOLDER/photo5/$frk_bukken_id.jpg" ] && echo "true" || echo "false")
        # 結果をCSVファイルに追記
        echo "$frk_bukken_id,$madori_exists,$photo_exists,$photo2_exists,$photo3_exists,$photo4_exists,$photo5_exists" >> "$OUTPUT_FILE_PATH"
    done < "/tmp/${FOLDER}_bukken_list.txt"

    # 一時ファイルの削除
    rm "/tmp/${FOLDER}_utf8.csv" "/tmp/${FOLDER}_bukken_list.txt"

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

