#!/bin/bash
sudo /opt/bitnami/ctlscript.sh stop
sudo lego --email="{replace-email}" --domains="{replace-domains}" --path="/etc/lego" renew
sudo /opt/bitnami/ctlscript.sh start