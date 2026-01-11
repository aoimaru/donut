## IDプロバイダの登録

# 流れ
# 1. GithubActionsを起動
# 2. GithubActionsがGithubにIDトークンの発行を依頼
#    補足: Githubは秘密鍵を既に作成済み ← 大事(@_@)
#        　JWKSエンドポイントも用意されているので公開鍵も取得可能
# 3. GiuthubがOIDCトークンを発行 ← 2の秘密鍵で署名済み
# 4. GithubActionがAWS_STSにAssumeRoleWithWebIdentityを要求
#    ここでGithubが発行したOIDCトークン(JWT)を送付
# 5. AWSがOIDCトークンを検証
#    JWKSエンドポイントにアクセスして公開鍵を取得 
# 6. トークンが正しければSTSが一時クレデンシャルを発行
#     この一時クレデンシャルには適切な権限(ロール)が紐づいている
# 7. GithubActionsが一時クレデンシャルを利用してAWS CLIを利用する


# resource "aws_iam_openid_connect_provider" "cicd" {
#   url             = "https://token.actions.githubusercontent.com"
#   client_id_list  = ["sts.amazonaws.com"]
#   # このコードは固定値
#   # OIDC ID プロバイダーのサムプリント
#   # GitHub証明書のルートCAのSHA-1フィンガープリン
#   thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
# }