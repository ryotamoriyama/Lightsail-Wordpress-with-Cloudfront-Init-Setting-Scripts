#!/bin/sh

#bitnami停止
sudo /opt/bitnami/ctlscript.sh stop

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



#bitnami起動
sudo /opt/bitnami/ctlscript.sh start