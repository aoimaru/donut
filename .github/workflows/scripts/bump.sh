#!/bin/bash


set -xue


# マージ元ブランチ名を引数で受け取る
BRANCH_NAME="$1"


# 最新タグを取得
git fetch --tags
LATEST_TAG=$(git tag --list 'v*.*.*' --sort=-v:refname | head -n 1)
if [[ -z "$LATEST_TAG" ]]; then
   MAJOR=0
   MINOR=0
   PATCH=0
else
   VERSION=${LATEST_TAG#v}
   IFS='.' read -r MAJOR MINOR PATCH <<<"$VERSION"
fi


case "$BRANCH_NAME" in
breaking/*)
   MAJOR=$((MAJOR + 1))
   MINOR=0
   PATCH=0
   ;;
feature/*)
   MINOR=$((MINOR + 1))
   PATCH=0
   ;;
fix/* | refactor/* | chore/*)
   PATCH=$((PATCH + 1))
   ;;
*)
   echo "ブランチ名が breaking/*, feature/*, fix/*, refactor/*, chore/* のいずれでもありません。"
   exit 1
   ;;
esac


NEW_TAG="v${MAJOR}.${MINOR}.${PATCH}"


# タグ作成
git tag "$NEW_TAG"
git push origin "$NEW_TAG"


echo "Created and pushed tag: $NEW_TAG"


# メジャーバージョンの最新タグを更新
MAJOR_TAG="v${MAJOR}"
git tag -f "$MAJOR_TAG"
git push origin -f "$MAJOR_TAG"


# マイナーバージョンの最新タグを更新
MINOR_TAG="v${MAJOR}.${MINOR}"
git tag -f "$MINOR_TAG"
git push origin -f "$MINOR_TAG"


echo "Updated latest tags: $MAJOR_TAG, $MINOR_TAG"



