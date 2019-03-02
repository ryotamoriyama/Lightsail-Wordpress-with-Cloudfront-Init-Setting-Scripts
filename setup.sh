#!/bin/sh

#bitnamiロゴ削除
sudo /opt/bitnami/apps/wordpress/bnconfig --disable_banner 1

#bitnami停止
sudo /opt/bitnami/ctlscript.sh stop

#/opt/bitnami/apache2/conf/httpd.conf の設定

#pagespeed無効化
sed -i -e 's|^Include conf/pagespeed.conf|#Include conf/pagespeed.conf|' /opt/bitnami/apache2/conf/httpd.conf
sed -i -e 's|^Include conf/pagespeed_libraries.conf|#Include conf/pagespeed_libraries.conf|' /opt/bitnami/apache2/conf/httpd.conf

#expires_module の有効化
sed -i -e 's|^#LoadModule expires_module modules/mod_expires.so|LoadModule expires_module modules/mod_expires.so|' /opt/bitnami/apache2/conf/httpd.conf

#/opt/bitnami/apps/wordpress/conf/httpd-app.conf の設定

#.htaccessの有効化
sed -i -e 's|AllowOverride None|AllowOverride All|' /opt/bitnami/apps/wordpress/conf/httpd-app.conf

#expires の設定
cat /opt/bitnami/apps/master/lib/mod_expires.txt >> /opt/bitnami/apps/wordpress/conf/httpd-app.conf