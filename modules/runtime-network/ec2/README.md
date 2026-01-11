# お金のかかるネットワークリソース

## 定義リソース
* ロードバランサ(`lb`)
    * ALBリスナー
        * ドメインでターゲットグループを切り替え
            * ec2.novapio.clickなら EC2インスタンス用のTG
            * ecs.novapio.clickなら ECSクラスタ用のTG
* NATゲートウェイ
* ドメイン・ホストゾーン(`Route53`)
* VPCエンドポイント