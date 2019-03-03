#!/bin/sh

#site_url・home_url変更
sed -i -e "s|^define('WP_SITEURL', 'http:\/\/' . \$_SERVER\['HTTP_HOST'\] . '\/');|define('WP_SITEURL', 'https:\/\/${1}\/');|" /opt/bitnami/apps/wordpress/htdocs/wp-config.php
sed -i -e "s|^define('WP_HOME', 'http:\/\/' . \$_SERVER\['HTTP_HOST'\] . '\/');|define('WP_SITEURL', 'https:\/\/${1}\/');|" /opt/bitnami/apps/wordpress/htdocs/wp-config.php

#$_SERVER['HTTP_HOST']指定
sed -i -e "97s|^|\n\$_SERVER['HTTP_HOST'] = ‘${1}’;\n\n|" /opt/bitnami/apps/wordpress/htdocs/wp-config.php

#プロトコルをCloudfrontに合わせる
sed -i -e "101s|^|\nif (isset(\$_SERVER['HTTP_X_FORWARDED_PROTO']) && \$_SERVER['HTTPX_FORWARDEDPROTO'] === 'https') {\n\t\$_SERVER['HTTPS'] = 'on';\n}\n\n|" /opt/bitnami/apps/wordpress/htdocs/wp-config.php

#WP CLI
cd /opt/bitnami/apps/wordpress/htdocs

#WordPressを最新版にアップデート
wp core update --allow-root

#プラグイン削除
wp plugin delete $(wp plugin list --status=inactive --field=name)

#テーマ削除
wp theme delete $(wp theme list --status=inactive --field=name)