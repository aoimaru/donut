# 恒久的に残すVPC外のリソースを定義
* ここも基本的にお金のかからないリソースを定義


## 定義リソース
### 実装したリソース
* IAM
    * IAMロール
        * EC2用のロール(AppサーバとOpmngサーバ)
        * SSM接続用のロール ← インスタンスプロファイルとしてEC2に設定((AppサーバとOpmngサーバ))
    * IAMポリシー
        * 権限ポリシー
        * 信頼ポリシー(assume設定)
            * 
        * ロールへポリシーをアタッチ
            * EC2用のロール
                * AmazonSSMManagedInstanceCore
                * SecretsManagerReadWrite
                * AmazonS3ReadOnlyAccess
            * SSM接続用のロール: 以下ポリシーをアタッチ
                * AmazonSSMManagedInstanceCore
                * SecretsManagerReadWrite ← こいついらないかも: 確認用で付与した記憶あり

    * インスタンスプロファイル
        * EC2用のロールのためのインスタンスプロファイル
        * SSM接続用のロールのためのインスタンスプロファイル
