#!/bin/sh

#site_url・home_url変更
sed -i -e "s|^define('WP_SITEURL', 'http://' . $_SERVER['HTTP_HOST'] . '/‘);|define('WP_SITEURL', 'https://${0}/‘)|" /opt/bitnami/apache2/conf/httpd.conf
sed -i -e "s|^define('WP_HOME', 'http://' . $_SERVER['HTTP_HOST'] . '/‘);|define('WP_SITEURL', 'https://${0}/‘)|" /opt/bitnami/apache2/conf/httpd.conf

#$_SERVER['HTTP_HOST']指定
sed -i -e "97s|^|$_SERVER['HTTP_HOST'] = ‘${0}’;|" /opt/bitnami/apps/wordpress/htdocs/wp-config.php

#プロトコルをCloudfrontに合わせる
sed -i -e "101s|^|if (isset($SERVER['HTTP_X_FORWARDED_PROTO']) && $SERVER['HTTPX_FORWARDEDPROTO'] === 'https') {\n$_SERVER['HTTPS'] = 'on';\n}|" /opt/bitnami/apps/wordpress/htdocs/wp-config.php