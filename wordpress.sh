#!/bin/sh

#site_url・home_url変更
sed -i -e "s|^define('WP_SITEURL', 'http:\/\/' . \$_SERVER\['HTTP_HOST'\] . '\/');|define('WP_SITEURL', 'https:\/\/${1}\/');|" /opt/bitnami/apps/wordpress/htdocs/wp-config.php
sed -i -e "s|^define('WP_HOME', 'http:\/\/' . \$_SERVER\['HTTP_HOST'\] . '\/');|define('WP_HOME', 'https:\/\/${1}\/');|" /opt/bitnami/apps/wordpress/htdocs/wp-config.php

#$_SERVER['HTTP_HOST']指定
sed -i -e "97s|^|\n\$_SERVER['HTTP_HOST'] = '${1}';\n\n|" /opt/bitnami/apps/wordpress/htdocs/wp-config.php

#プロトコルをCloudfrontに合わせる
sed -i -e "101s|^|\nif (isset(\$_SERVER['HTTP_X_FORWARDED_PROTO']) \&\& \$_SERVER['HTTPX_FORWARDEDPROTO'] === 'https') {\n\t\$_SERVER['HTTPS'] = 'on';\n}\n\n|" /opt/bitnami/apps/wordpress/htdocs/wp-config.php

#WP CLI
cd /opt/bitnami/apps/wordpress/htdocs

#WordPressを最新版にアップデート
wp core update --locale=ja --allow-root

#日本語ファイルインストール
wp language core install ja --allow-root

#プラグイン削除
wp plugin delete --allow-root $(wp plugin list --status=inactive --field=name --allow-root)

#テーマ削除
wp theme delete --allow-root $(wp theme list --status=inactive --field=name --allow-root)

#タイムゾーン変更
wp option update timezone_string 'Asia/Tokyo' --allow-root

#言語設定
wp option update WPLANG 'ja' --allow-root

#ログインパスワード変更
if [ -n "$3" ]; then
wp user update 1 --user_pass=${3} --allow-root
else
wp user update 1 --user_pass=passwd --allow-root
fi

#ログインユーザー名変更
if [ -n "$2" ]; then
wp db query "UPDATE wp_users SET user_login = \"${2}\" WHERE ID = 1" --allow-root
fi