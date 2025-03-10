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
  if [[ "$KEY" == *new_estate.json ]]; then
    # JSONファイルをダウンロードして処理
    TMP_FILE=$(mktemp)
    aws s3 cp "s3://${RECAT_S3_BUCKET}/${KEY}" "$TMP_FILE"
    
    # jqを使ってJSONを処理
    jq -c '.[]' "$TMP_FILE" | while read -r BUKKEN; do
      BUKKEN_ID=$(echo "$BUKKEN" | jq -r '.bukken_id')
      FTP_USER=$(echo "$BUKKEN" | jq -r '.ftp_user')

      # ディレクトリ作成
      DIR="/home/frk_ftp/works/new_estate_images/${BUKKEN_ID}"
      mkdir -p "$DIR"
      
      SOURCE_DIR="/home/frk_ftp/works/agents/${FTP_USER}/sale/image"
      
      # 画像の移動
      echo "$BUKKEN" | jq -r '.images[]' | while read -r IMAGE_PATH; do
        if [ -f "${SOURCE_DIR}/${IMAGE_PATH}" ]; then
          # パスからディレクトリ名を抽出
          DIR_NAME=$(echo "$IMAGE_PATH" | cut -d'/' -f1)
          
          # 拡張子を取得
          EXTENSION="${IMAGE_PATH##*.}"
          
          # 新しいファイル名を作成
          NEW_FILENAME="${DIR_NAME}.${EXTENSION}"
          
          # ファイルを新しい名前でコピー
          cp "${SOURCE_DIR}/${IMAGE_PATH}" "${DIR}/${NEW_FILENAME}"
        fi
      done
    done
    
    # 一時ファイルを削除
    rm "$TMP_FILE"
  fi
done
