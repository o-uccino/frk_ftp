#!/bin/bash
set -e

# 環境変数を読み込む
AWS_REGION='ap-northeast-1'
export AWS_REGION

# 環境設定ファイルから変数を読み込む
RECAT_S3_BUCKET="recat-staging"

# 今日の日付パターンを作成
TARGET_PATTERN=$(date +"%Y-%m-%d")

# S3からオブジェクトリストを取得
KEYS=$(aws s3 ls "s3://${RECAT_S3_BUCKET}/estates_import/frk_image_sync/${TARGET_PATTERN}" --recursive | awk '{print $4}')

# new_estate.jsonで終わるファイルを処理
for KEY in $KEYS; do
  echo "$KEY"
  if [[ "$KEY" == *new_estate.json ]]; then
    # JSONファイルをダウンロードして処理
    TMP_FILE=$(mktemp)
    aws s3 cp "s3://${RECAT_S3_BUCKET}/${KEY}" "$TMP_FILE"
    
    # jqを使ってJSONを処理
    jq -c '.[]' "$TMP_FILE" | while read -r BUKKEN; do
      BUKKEN_ID=$(echo "$BUKKEN" | jq -r '.bukken_id')
      FTP_USER=$(echo "$BUKKEN" | jq -r '.ftp_user')
      FRK_BUKKEN_ID=$(echo "$BUKKEN" | jq -r '.frk_bukken_id')
      
      echo "Processing bukken_id: $BUKKEN_ID"
      echo "FTP user: $FTP_USER"
      echo "FRK bukken_id: $FRK_BUKKEN_ID"

      # 新しいディレクトリ構造を作成
      TARGET_DIR="/home/frk_ftp/works/new_estate_images/${BUKKEN_ID}"
      mkdir -p "$TARGET_DIR"
      
      # 元のディレクトリパス
      SOURCE_BASE="/home/frk_ftp/works/agents/${FTP_USER}"
      
      if [[ "$FRK_BUKKEN_ID" =~ ^[0-9A-Za-z]{8}$ ]]; then
        # 間取り図のコピー
        if [ -f "${SOURCE_BASE}/madori/${FRK_BUKKEN_ID}.jpg" ]; then
          cp "${SOURCE_BASE}/madori/${FRK_BUKKEN_ID}.jpg" "${TARGET_DIR}/madori.jpg"
          echo "Copied madori: ${FRK_BUKKEN_ID}.jpg"
        fi
        
        # 写真のコピー（photo1-5）
        for i in {1..5}; do
          SOURCE_FILE="${SOURCE_BASE}/photo${i}/${FRK_BUKKEN_ID}.jpg"
          if [ -f "$SOURCE_FILE" ]; then
            if [ "$i" -eq 1 ]; then
              cp "$SOURCE_FILE" "${TARGET_DIR}/external_${FRK_BUKKEN_ID}.jpg"
              echo "Copied external: ${FRK_BUKKEN_ID}.jpg"
            else
              cp "$SOURCE_FILE" "${TARGET_DIR}/content0${i}_${FRK_BUKKEN_ID}.jpg"
              echo "Copied content0${i}: ${FRK_BUKKEN_ID}.jpg"
            fi
          fi
        done
      else
        echo "Warning: FRK bukken_id is not 8 digits: $FRK_BUKKEN_ID"
      fi
    done
    
    # 一時ファイルを削除
    rm "$TMP_FILE"
  fi
done 
