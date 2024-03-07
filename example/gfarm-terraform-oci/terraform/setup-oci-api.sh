#!/bin/bash

set -eu
set -x

# SEE: https://oracle-japan.github.io/ocitutorials/intermediates/terraform/

PUBKEY=./ociapi_public.pem
PRIVKEY=./ociapi_private.pem

if [ -f $PRIVKEY ]; then
    # check
    cat $PUBKEY > /dev/null
    cat $PRIVKEY > /dev/null
    echo Existing: $PUBKEY $PRIVKEY
    exit 0
fi

# 1. ociディレクトリの作成
#mkdir $HOME/.oci

# 2. 秘密鍵の作成　<your-rsa-key-name>には適当な名前を入力
openssl genrsa -out $PRIVKEY 2048

# 3. 権限の変更
chmod 600 $PRIVKEY

# 4. 公開キーの作成
openssl rsa -pubout -in $PRIVKEY -out $PUBKEY

# 5. 公開キーをコンソールに登録
cat $PUBKEY

# 6. アイデンティティ -> 自分のプロファイル -> APIキー -> 公開キーの追加
# 7. 公開キーの貼付け -> EGIN PUBLIC KEYおよびEND PUBLIC KEYの行を含む値を貼り付け -> 追加
