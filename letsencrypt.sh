#!/bin/sh

#bitnami停止
sudo /opt/bitnami/ctlscript.sh stop

#Let's encrypt
cd /tmp
curl -s https://api.github.com/repos/xenolf/lego/releases/latest | grep browser_download_url | grep linux_amd64 | cut -d '"' -f 4 | wget -i -

for filename in /tmp/lego_v*_linux_amd64.tar.gz; do
  last=${filename#/tmp/lego_v*}
  version=${last%%_*}
  if [ -n "$version" ]; then
  break
  fi
done

echo $last
echo $version

tar xf "/tmp/lego_v${version}_linux_amd64.tar.gz"

sudo mv lego /usr/local/bin/lego

echo ${2}

echo ${1}

#Apacheにインストール
sudo lego --email="${2}" --domains="${1}" --path="/etc/lego" --tls run

sudo mv /opt/bitnami/apache2/conf/server.crt /opt/bitnami/apache2/conf/server.crt.old
sudo mv /opt/bitnami/apache2/conf/server.key /opt/bitnami/apache2/conf/server.key.old
sudo mv /opt/bitnami/apache2/conf/server.csr /opt/bitnami/apache2/conf/server.csr.old
sudo ln -s "/etc/lego/certificates/${1}.key" /opt/bitnami/apache2/conf/server.key
sudo ln -s "/etc/lego/certificates/${1}.crt" /opt/bitnami/apache2/conf/server.crt
sudo chown root:root /opt/bitnami/apache2/conf/server*
sudo chmod 600 /opt/bitnami/apache2/conf/server*

#証明書更新用スクリプトの作成
sudo cp -f /opt/bitnami/apps/Lightsail-Wordpress-with-Cloudfront-Init-Setting-Scripts/lib/renew-certificate.sh /etc/lego/renew-certificate.sh
sudo sed -i -e "s|{replace-email}|${2}|" /etc/lego/renew-certificate.sh
sudo sed -i -e "s|{replace-domains}|${1}|" /etc/lego/renew-certificate.sh

#crontab登録
sudo rm -Rf /var/spool/cron/crontabs/root
sudo cp -f /opt/bitnami/apps/Lightsail-Wordpress-with-Cloudfront-Init-Setting-Scripts/lib/crontab /var/spool/cron/crontabs/root

#bitnami起動
sudo /opt/bitnami/ctlscript.sh start