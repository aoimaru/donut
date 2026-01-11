# 



# 補足コマンド
## 購入済みのドメインを確認するコマンド
```bash
aoimaru@aoimaru:~/document/terraform_project$ aws route53domains list-domains --region us-east-1
{
    "Domains": [
        {
            "DomainName": "novapio.click",
            "AutoRenew": false,
            "TransferLock": false,
            "Expiry": "2026-11-02T13:58:55.277000+09:00"
        }
    ]
}
```
* Route53にホストゾーンを作成する際は, IDなどではなくドメイン名(`novapio.click`)で参照する


# 補足情報
## DNS情報(`dig`結果)
```bash
aoimaru@aoimaru:~$ dig novapio.click

; <<>> DiG 9.18.30-0ubuntu0.20.04.2-Ubuntu <<>> novapio.click
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 6823
;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 512
;; QUESTION SECTION:
;novapio.click.                 IN      A

;; AUTHORITY SECTION:
novapio.click.          900     IN      SOA     ns-1151.awsdns-15.org. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400

;; Query time: 590 msec
;; SERVER: 10.255.255.254#53(10.255.255.254) (UDP)
;; WHEN: Tue Dec 30 13:59:13 JST 2025
;; MSG SIZE  rcvd: 127
```
### 状況
* ホストゾーンは存在しているけど、Aレコードは存在していない

### 詳細
```bash
;; AUTHORITY SECTION:
novapio.click.          900     IN      SOA     ns-1151.awsdns-15.org. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400
```
* AUTHORITY SECTION: 権威DNSサーバの情報 要は`公式回答者`
    * この結果なら, `ns-1151.awsdns-15.org`が権威DNSサーバ
    * このサーバが`novapio.click`の結果を返却する