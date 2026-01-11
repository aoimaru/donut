#!/usr/bin/env bash
# ------ bashのパスを環境変数から取得する(ディストリビューション非依存) ------

# ルート直下で実行する

# 鍵の出力ファイル名
PRIVATE_KEY_FILE="privateref.key"
PUBLIC_KEY_FILE="publicref.key"
ENVRC_FILE=".envrc"

# 鍵の生成
openssl genrsa -out "$PRIVATE_KEY_FILE" 2048
openssl rsa -in "$PRIVATE_KEY_FILE" -pubout -out "$PUBLIC_KEY_FILE"
