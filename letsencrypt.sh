#!/bin/sh

#bitnami停止
sudo /opt/bitnami/ctlscript.sh stop

#Let's encrypt
cd /tmp
curl -s https://api.github.com/repos/xenolf/lego/releases/latest | grep browser_download_url | grep linux_amd64 | cut -d '"' -f 4 | wget -i -

for filename in /tmp/lego_v*_linux_amd64.tar.gz; do
  last=${filename#./lib/lego_v*}
  version=${last%%_*}
  if [ -n "$version" ]; then
  break
  fi
done

tar xf "lego_${version}_linux_amd64.tar.gz"

sudo mv lego /usr/local/bin/lego

#Apacheにインストール
sudo lego --email="${2}" --domains="${0}" --path="/etc/lego" --tls run

sudo mv /opt/bitnami/apache2/conf/server.crt /opt/bitnami/apache2/conf/server.crt.old
sudo mv /opt/bitnami/apache2/conf/server.key /opt/bitnami/apache2/conf/server.key.old
sudo mv /opt/bitnami/apache2/conf/server.csr /opt/bitnami/apache2/conf/server.csr.old
sudo ln -s "/etc/lego/certificates/${1}.key" /opt/bitnami/apache2/conf/server.key
sudo ln -s "/etc/lego/certificates/${1}.crt" /opt/bitnami/apache2/conf/server.crt
sudo chown root:root /opt/bitnami/apache2/conf/server*
sudo chmod 600 /opt/bitnami/apache2/conf/server*

#証明書更新用スクリプトの作成


#bitnami起動
sudo /opt/bitnami/ctlscript.sh start