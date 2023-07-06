

#!/bin/bash

if [ ! -f FTT ]; then

wget  "https://raw.githubusercontent.com/radkesvat/FakeTlsTunnel/master/install.sh" -O install.sh && chmod +x install.sh && bash install.sh

fi

read -p "Select 'i' for internal and 'o' for outside server : " choice
read -p "Enter the port number: " port
read -p "Enter the tunneling port number: " tport
read -p "Enter the service number: " number

if [[ "$choice" == "i" ]]; then
  read -p "Enter your ip " ip
  execstart="--tunnel --lport:$port --toip:$ip --toport:$tport --sni:data.services.jetbrains.com --password:doodool"
else
  execstart="--server --lport:$tport --toip:127.0.0.1 --toport:$port --sni:data.services.jetbrains.com --password:doodool"
fi
echo "[Unit]
Description=Faketls tunnel $number
After=network.target
Wants=network.target
[Service]
Type=simple
ExecStart=/root/FTT $execstart
Restart=always
RestartSec=3
[Install]
WantedBy=multi-user.target" > /etc/systemd/system/ftt$number.service

ufw allow $tport
ufw allow $port

systemctl daemon-reload
systemctl enable ftt$number
systemctl restart ftt$number
systemctl start ftt$number
systemctl status ftt$number
