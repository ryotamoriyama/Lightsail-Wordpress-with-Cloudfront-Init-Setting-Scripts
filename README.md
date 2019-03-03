# Lightsail WordPressをCloudfrontで運用するためのセットアップスクリプト

## 導入フロー
順序通りに作業してください

1. Static IPを作成する（Lightsail→ネットワーク→静的IPの作成）
2. Lightsail用のドメインのAレコードを1で作成したIPに向ける
3. WordPressインスタンスを作成する
4. 10分ほど放置する（※重要）
5. 1で作成したStatic IPに3で作成したインスタンスをアタッチする
6. Lightsail用のドメインにアクセスし、表示されるか確認する
7. SSH接続する（ブラウザからでも可）
8. 当該リポジトリをプルする ` sudo git clone https://github.com/ryotamoriyama/Lightsail-Wordpress-with-Cloudfront-Init-Setting-Scripts.git /opt/bitnami/apps/Lightsail-Wordpress-with-Cloudfront-Init-Setting-Scripts`
9. コマンドを実行する`sudo bash /opt/bitnami/apps/Lightsail-Wordpress-with-Cloudfront-Init-Setting-Scripts/setup.sh {公開用ドメイン} {Lightsail用ドメイン} {証明書登録用メールアドレス} {WordPressログインユーザー名} {WordPressログインパスワード}`