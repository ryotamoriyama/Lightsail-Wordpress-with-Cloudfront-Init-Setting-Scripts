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

#Apacheにインストール
sudo lego --email="${3}" --domains="${2}" --path="/etc/lego" --tls run

sudo mv /opt/bitnami/apache2/conf/server.crt /opt/bitnami/apache2/conf/server.crt.old
sudo mv /opt/bitnami/apache2/conf/server.key /opt/bitnami/apache2/conf/server.key.old
sudo mv /opt/bitnami/apache2/conf/server.csr /opt/bitnami/apache2/conf/server.csr.old
sudo ln -s "/etc/lego/certificates/${2}.key" /opt/bitnami/apache2/conf/server.key
sudo ln -s "/etc/lego/certificates/${2}.crt" /opt/bitnami/apache2/conf/server.crt
sudo chown root:root /opt/bitnami/apache2/conf/server*
sudo chmod 600 /opt/bitnami/apache2/conf/server*

#証明書更新用スクリプトの作成
sudo cp -f /opt/bitnami/apps/Lightsail-Wordpress-with-Cloudfront-Init-Setting-Scripts/lib/renew-certificate.sh /etc/lego/renew-certificate.sh
sudo sed -i -e "s|{replace-email}|${3}|" /etc/lego/renew-certificate.sh
sudo sed -i -e "s|{replace-domains}|${2}|" /etc/lego/renew-certificate.sh

#crontab登録
cron_file=/var/spool/cron/crontabs/root
[ -f ${cron_file} ] && touch ${cron_file}
sudo echo '0 0 1 * * /etc/lego/renew-certificate.sh 2> /dev/null' >> "${cron_file}"

#bitnami起動
sudo /opt/bitnami/ctlscript.sh start