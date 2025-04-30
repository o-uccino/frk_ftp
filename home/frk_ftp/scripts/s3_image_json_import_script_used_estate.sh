#!/bin/bash
set -e

# 環境変数を読み込む
AWS_REGION='ap-northeast-1'
export AWS_REGION

source /home/frk_ftp/scripts/environment

# 今日の日付パターンを作成
TARGET_PATTERN=$(date +"%Y-%m-%d")

# S3からオブジェクトリストを取得
KEYS=$(aws s3 ls "s3://${RECAT_S3_BUCKET}/estates_import/frk_image_sync/${TARGET_PATTERN}" --recursive | awk '{print $4}')

mkdir -p /home/frk_ftp/works/used_estate_images

# used_estate.jsonで終わるファイルを処理
for KEY in $KEYS; do
  if [[ "$KEY" == *used_estate.json ]]; then
    # ファイル名からclient_idを抽出（バックアップとして保持）
    FILENAME=$(basename "$KEY")
    FILENAME_CLIENT_ID=$(echo "$FILENAME" | cut -d'_' -f1)
    
    # JSONファイルをダウンロードして処理
    TMP_FILE=$(mktemp)
    aws s3 cp "s3://${RECAT_S3_BUCKET}/${KEY}" "$TMP_FILE"
    
    # jqを使ってJSONを処理
    jq -c '.[]' "$TMP_FILE" | while read -r BUKKEN; do
      # JSONからclient_idを取得する
      CLIENT_ID=$(echo "$BUKKEN" | jq -r '.client_id')
      # client_idが空または存在しない場合はファイル名から抽出したものを使用
      if [ -z "$CLIENT_ID" ] || [ "$CLIENT_ID" == "null" ]; then
        CLIENT_ID=$FILENAME_CLIENT_ID
        echo "Warning: client_id not found in JSON, using fallback from filename: $CLIENT_ID"
      else
        echo "Client ID from JSON: $CLIENT_ID"
      fi
      
      BUKKEN_ID=$(echo "$BUKKEN" | jq -r '.bukken_id')
      FTP_USER=$(echo "$BUKKEN" | jq -r '.ftp_user')
      FRK_BUKKEN_ID=$(echo "$BUKKEN" | jq -r '.frk_bukken_id')
      
      echo "Processing bukken_id: $BUKKEN_ID"
      echo "FTP user: $FTP_USER"
      echo "FRK bukken_id: $FRK_BUKKEN_ID"

      # ディレクトリ作成
      TARGET_DIR="/home/frk_ftp/works/used_estate_images/${CLIENT_ID}/${BUKKEN_ID}"
      mkdir -p "$TARGET_DIR"
      echo "Target directory: $TARGET_DIR"
      
      # frk_bukken_idのバリデーション
      if [[ -z "$FRK_BUKKEN_ID" || "$FRK_BUKKEN_ID" == "null" ]]; then
        echo "Warning: frk_bukken_id is missing or null, cannot proceed with this record"
        continue
      fi
      
      # 元のディレクトリパス
      SOURCE_BASE="/home/frk_ftp/works/${FTP_USER}"
      echo "Source base directory: $SOURCE_BASE"
      
      # FRK_BUKKEN_IDが正しい形式であるか確認（8桁の英数字）
      if [[ "$FRK_BUKKEN_ID" =~ ^[0-9A-Za-z]{8}$ ]]; then
        # 間取り図のコピー
        if [ -f "${SOURCE_BASE}/madori/${FRK_BUKKEN_ID}.jpg" ]; then
          cp "${SOURCE_BASE}/madori/${FRK_BUKKEN_ID}.jpg" "${TARGET_DIR}/madori.jpg"
          echo "Copied madori: ${FRK_BUKKEN_ID}.jpg"
        fi
        
        # 写真のコピー（photo1-5）
        for i in {1..5}; do
          if [ "$i" -eq 1 ]; then
            SOURCE_FILE="${SOURCE_BASE}/photo/${FRK_BUKKEN_ID}.jpg"
            if [ -f "$SOURCE_FILE" ]; then
              cp "$SOURCE_FILE" "${TARGET_DIR}/photo.jpg"
              echo "Copied external: ${FRK_BUKKEN_ID}.jpg"
            fi
          fi
          SOURCE_FILE="${SOURCE_BASE}/photo${i}/${FRK_BUKKEN_ID}.jpg"
          if [ -f "$SOURCE_FILE" ]; then
            cp "$SOURCE_FILE" "${TARGET_DIR}/photo${i}.jpg"
            echo "Copied photo${i}: ${FRK_BUKKEN_ID}.jpg"
          fi
        done
      else
        echo "Warning: FRK_BUKKEN_ID format is invalid: $FRK_BUKKEN_ID"
      fi
    done
    
    # 一時ファイルを削除
    rm "$TMP_FILE"
  fi
done

# ディレクトリの権限を設定
chmod -R 0777 /home/frk_ftp/works/used_estate_images/ 
