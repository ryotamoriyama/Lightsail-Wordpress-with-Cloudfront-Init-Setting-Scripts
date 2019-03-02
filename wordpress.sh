#!/bin/sh

#site_url・home_url変更
sed -i -e "s|'http://' . $_SERVER['HTTP_HOST'] . '/'|'https://${1}/‘|g" /opt/bitnami/apps/wordpress/htdocs/wp-config.php

#$_SERVER['HTTP_HOST']指定
sed -i -e "97s|^|\n$_SERVER['HTTP_HOST'] = ‘${1}’;\n\n|" /opt/bitnami/apps/wordpress/htdocs/wp-config.php

#プロトコルをCloudfrontに合わせる
sed -i -e "101s|^|\nif (isset($SERVER['HTTP_X_FORWARDED_PROTO']) && $SERVER['HTTPX_FORWARDEDPROTO'] === 'https') {\n\t$_SERVER['HTTPS'] = 'on';\n}\n\n|" /opt/bitnami/apps/wordpress/htdocs/wp-config.php