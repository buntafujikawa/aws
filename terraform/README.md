# terraformでawsを操作する方法
 
## 使い方
[最低限の設定でec2を立ち上げる](http://qiita.com/bunty/items/5ceed66d334db0ff99e8)か[公式のマニュアル](https://www.terraform.io/docs/providers/aws/r/security_group.html)があるのでこちらを参考にする


## 設定 

terraformディレクトリ内に`terraform.tfvars`を作成し、変数として使用している値を入力しておく
アクセスキーに関してはセキュリティ認証情報から確認可能
シークレットキーはアクセスキー作成時にのみ確認ができるため、安全な場所に保管しておくか忘れたら再度作り直す必要がある

```
 [bunta.fujikawa]$ cat terraform/terraform.tfvars   
aws_access_key = "YOUR_ACCESS_KEY"
aws_secret_key = "YOUR_SECRET_KEY"

# db
database_name   = "DB_NAME"
aws_db_username = "USER_NAME"
aws_db_password = "PASSWORD"%        

```

[git-secrets](https://qiita.com/pottava/items/4c602c97aacf10c058f1)を使ってgithubに載せないようにするのも良いと思う


TODO  
・terraform.tfstateに関しては後日記載