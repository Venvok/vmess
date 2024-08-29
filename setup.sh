#!/bin/bash
clear
clear
[[ -e $(which curl) ]] && if [[ -z $(cat /etc/resolv.conf | grep "1.1.1.1") ]]; then cat <(echo "nameserver 1.1.1.1") /etc/resolv.conf > /etc/resolv.conf.tmp && mv /etc/resolv.conf.tmp /etc/resolv.conf; fi
clear

#Bikin File
clear
mkdir -p /etc/xray
mkdir -p /var
mkdir -p /var/lib
mkdir -p /var/log
mkdir -p /var/log/xray
touch /var/log/xray/access.log
chmod +x /var/log/xray/*
clear

read -rp "Masukkan Domain: " domain
echo "$domain" > /etc/xray/domain
clear

clear
cd;
apt-get update;

#Remove unused Module
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove sendmail*;
apt-get -y --purge remove bind9*;
apt-get -y --purge remove apache2*
apt remove apache2 -y
apt autoremove -y

clear

#install toolkit
apt-get install libio-socket-inet6-perl libsocket6-perl libcrypt-ssleay-perl libnet-libidn-perl perl libio-socket-ssl-perl libwww-perl libpcre3 libpcre3-dev zlib1g-dev dbus iftop zip unzip wget net-tools curl nano sed screen gnupg gnupg1 bc apt-transport-https build-essential dirmngr dnsutils sudo at htop iptables bsdmainutils cron lsof lnav -y

#Install tools
apt install binutils -y
apt install socat -y
apt install lolcat -y
apt install ruby -y
gem install lolcat
apt install lolcat -y
apt install wget curl -y
apt install htop -y
apt install speedtest-cli -y
apt install cron -y
apt install figlet -y
apt install zip unzip -y
apt install jq -y
apt install certbot -y
apt install python2 -y
apt install python3 -y
apt install screen -y
apt install haproxy -y
apt install at -y

#install socat
apt install iptables -y
apt install curl socat xz-utils wget apt-transport-https gnupg gnupg2 gnupg1 dnsutils lsb-release -y 
apt install socat cron bash-completion -y

# Konfigurasi OpenSSH
cd /etc/ssh
rm -fr /etc/ssh/sshd_config
wget -O sshd_config "https://raw.githubusercontent.com/DindaPutriFN/FN-API/main/config/sshd_config"
systemctl daemon-reload
systemctl restart ssh
systemctl restart sshd

#Apache2 Fix
systemctl daemon-reload
systemctl stop apache2
systemctl disable apache2

link="https://filebin.net/rfmck7fpkevheqvp"
# Konfigurasi Menu
cd /usr/bin
wget -O menu "$link/menu.sh"
wget -O backup "$link/backup.sh"
wget -O xp "$link/xp.sh"

#Konfigurasi Xray
wget -O /usr/bin/xray "https://raw.githubusercontent.com/Rerechan02/Rerechan02/main/xray"
chmod +x /usr/bin/xray
clear
cd /etc/xray
wget -O /etc/xray/config.json "$link/config.json"
chmod +x /etc/xray/*

#install nginx
apt install nginx -y
rm /etc/nginx/conf.d/default.conf
cd /etc/nginx 
rm -fr nginx.conf
wget -q -O /etc/nginx/nginx.conf "$link/nginx.conf"
cd

echo "0 0 * * * root xp" >> /etc/crontab

# delete
systemctl stop nginx
rm -fr /etc/xray/xray*
rm -fr /etc/xray/funny.pem

sudo lsof -t -i tcp:80 -s tcp:listen | sudo xargs kill
cd /root/
wget https://raw.githubusercontent.com/acmesh-official/acme.sh/master/acme.sh
bash acme.sh --install
rm acme.sh
cd .acme.sh
bash acme.sh --register-account -m rere@rerechan02.com
bash acme.sh --issue --standalone -d $domain --force
bash acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key

#install firewall
apt install ufw -y
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw allow 80/tcp
sudo ufw allow 8880/tcp
sudo ufw allow 443/tcp
sudo ufw allow 1194/tcp
sudo ufw allow 447/tcp
sudo ufw allow 444/tcp
sudo ufw allow 777/tcp
sudo ufw allow 2080/tcp
sudo ufw allow 2082/tcp
sudo ufw allow 2200/udp
yes | sudo ufw enable

# Install Warp Cloudflare
cd /root; wget -O wgcf.sh "https://raw.githubusercontent.com/DindaPutriFN/warp/main/install-warp.sh"; chmod +x /root/*; /root/wgcf.sh; rm -fr /root/*

# // Membuat Service
cat> /etc/systemd/system/xray.service << END
[Unit]
Description=Xray by FunnyVPN
Documentation=https://indo-ssh.com
After=network.target nss-lookup.target

[Service]
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/xray -config /etc/xray/config.json
Restart=on-failure
RestartPreventExitStatus=23

[Install]
WantedBy=multi-user.target
END

clear
systemctl demon-reload
systemctl enable xray
systemctl enable cron

systemctl start xray
systemctl start crom

systemctl restart cron
systemctl restart xray
systemctl restart nginx

clear

echo ""
echo -e "\033[96m_______________________________\033[0m"
echo -e "\033[92m         INSTALL SUCCES\033[0m"
echo -e "\033[96m_______________________________\033[0m"
sleep 1.5