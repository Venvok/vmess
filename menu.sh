#!/bin/bash
clear

add() {
clear
domain=$(cat /etc/xray/domain)
clear
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\\E[40;1;37m      Add Xray/vmessws Account      \E[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
read -p "Username         : " user
read -p "Masaaktif        : " masaaktif

		CLIENT_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
clear
            echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
            echo -e "\\E[40;1;37m      Add Xray/vmessws Account      \E[0m"
            echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
			echo ""
			echo "A client with the specified name was already created, please choose another name."
			echo ""
			echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
			read -n 1 -s -r -p "Press any key to back on menu"
menu
		fi
	done

uuid=$(cat /proc/sys/kernel/random/uuid)
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#vmess$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/config.json
acs=`cat<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "443",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/vmess",
      "type": "none",
      "host": "${domain}",
      "tls": "tls"
}
EOF`
ask=`cat<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "80",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/vmess",
      "type": "none",
      "host": "${domain}",
      "tls": "none"
}
EOF`
vmess_base641=$( base64 -w 0 <<< $vmess_json1)
vmess_base642=$( base64 -w 0 <<< $vmess_json2)
vmess_base643=$( base64 -w 0 <<< $vmess_json3)
vmesslink1="vmess://$(echo $acs | base64 -w 0)"
vmesslink2="vmess://$(echo $ask | base64 -w 0)"
systemctl restart xray > /dev/null 2>&1
service cron restart > /dev/null 2>&1
clear
echo -e "══════════════════════════"
echo -e "    <=  VMESS ACCOUNT =>"
echo -e "══════════════════════════"
echo -e ""
echo -e "Username     : $user"
echo -e "Host/IP      : $domain"
echo -e "Port ssl/tls : 443"
echo -e "Port non tls : 80"
echo -e "Key          : $uuid"
echo -e "Network      : ws"
echo -e "Path         : /vmess"
echo -e ""
echo -e "══════════════════════════"
echo -e "Link Tls  => ${vmesslink1}"
echo -e "══════════════════════════"
echo -e "Link None => ${vmesslink2}"
echo -e "══════════════════════════"
echo -e "   Expired => $exp"
echo -e "══════════════════════════"
}

delete() {
# ==========================================
NC='\e[0m'
DEFBOLD='\e[39;1m'
RB='\e[31;1m'
GB='\e[32;1m'
YB='\e[33;1m'
BB='\e[34;1m'
MB='\e[35;1m'
CB='\e[35;1m'
WB='\e[37;1m'
clear
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/xray/config.json")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "                ${GB}Delete Xray Account${NC}                "
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "  ${YB}You have no existing clients!${NC}"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
read -n 1 -s -r -p "Press any key to back on menu"
menu
fi
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "                ${GB}Delete Xray Account${NC}                "
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e " ${YB}User  Expired${NC}  "
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
grep -E "^### " "/etc/xray/config.json" | cut -d ' ' -f 2-3 | column -t | sort | uniq
echo ""
echo -e "${YB}tap enter to go back${NC}"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
read -rp "Input Username : " user
if [ -z $user ]; then
vmess
else
exp=$(grep -wE "^### $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
sed -i "/^### $user $exp/,/^},{/d" /etc/xray/config.json
systemctl restart xray
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "           ${GB}Xray Account Success Deleted${NC}            "
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e " ${YB}Client Name :${NC} $user"
echo -e " ${YB}Expired On  :${NC} $exp"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
clear
menu
fi
}

extend() {
NC='\e[0m'
DEFBOLD='\e[39;1m'
RB='\e[31;1m'
GB='\e[32;1m'
YB='\e[33;1m'
BB='\e[34;1m'
MB='\e[35;1m'
CB='\e[35;1m'
WB='\e[37;1m'
clear
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/xray/config.json")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "                ${GB}Extend Xray Account${NC}               "
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "  ${YB}You have no existing clients!${NC}"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
menu
fi
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "                ${GB}Extend Xray Account${NC}               "
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e " ${YB}User  Expired${NC}  "
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
grep -E "^### " "/etc/xray/config.json" | cut -d ' ' -f 2-3 | column -t | sort | uniq
echo ""
echo -e "${YB}tap enter to go back${NC}"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
read -rp "Input Username : " user
if [ -z $user ]; then
menu
else
read -p "Expired (days): " masaaktif
exp=$(grep -wE "^### $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
now=$(date +%Y-%m-%d)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
exp3=$(($exp2 + $masaaktif))
exp4=`date -d "$exp3 days" +"%Y-%m-%d"`
sed -i "/### $user/c\### $user $exp4" /etc/xray/config.json
systemctl restart xray
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "           ${GB}Xray Account Success Extended${NC}            "
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e " ${YB}Client Name :${NC} $user"
echo -e " ${YB}Expired On  :${NC} $exp4"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
clear
menu
fi

}

login() {
clear
echo -n > /tmp/other.txt
data=( `cat /etc/xray/config.json | grep '###' | cut -d ' ' -f 2 | sort | uniq`);
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "     =[ VMESS User Login ]=         "
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
for akun in "${data[@]}"
do
if [[ -z "$akun" ]]; then
akun="tidakada"
fi
echo -n > /tmp/ipxray.txt
data2=( `cat /var/log/xray/access.log | tail -n 500 | cut -d " " -f 3 | sed 's/tcp://g' | cut -d ":" -f 1 | sort | uniq`);
for ip in "${data2[@]}"
do
jum=$(cat /var/log/xray/access.log | grep -w "$akun" | tail -n 500 | cut -d " " -f 3 | sed 's/tcp://g' | cut -d ":" -f 1 | grep -w "$ip" | sort | uniq)
if [[ "$jum" = "$ip" ]]; then
echo "$jum" >> /tmp/ipxray.txt
else
echo "$ip" >> /tmp/other.txt
fi
jum2=$(cat /tmp/ipxray.txt)
sed -i "/$jum2/d" /tmp/other.txt > /dev/null 2>&1
done
jum=$(cat /tmp/ipxray.txt)
if [[ -z "$jum" ]]; then
echo > /dev/null
else
jum2=$(cat /tmp/ipxray.txt | nl)
lastlogin=$(cat /var/log/xray/access.log | grep -w "$akun" | tail -n 500 | cut -d " " -f 2 | tail -1)
echo -e "user :${GREEN} ${akun} ${NC}
${RED}Online Jam ${NC}: ${lastlogin} wib";
echo -e "$jum2";
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
fi
rm -rf /tmp/ipxray.txt
done
rm -rf /tmp/other.txt

echo ""
read -n 1 -s -r -p "Press any key to back on menu"
menu
}

cert1() {
clear
echo -e "[ ${green}INFO${NC} ] Start " 
sleep 0.5
NC='\e[0m'
green='\033[0;92m'       # Green
systemctl stop nginx
domain=$(cat /etc/xray/domain)
rm -fr /etc/haproxy/funny.pem
rm -fr /etc/xray/xray.crt
rm -fr /etc/xray/xray.key
sleep 1
echo -e "[ ${red}WARNING${NC} ] Detected port 80 used by Nginx " 
sleep 2
echo -e "[ ${green}INFO${NC} ] Processing to stop $Cek " 
sleep 1
clear
echo -e "[ ${green}INFO${NC} ] Starting renew cert... " 
sleep 2
clear
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
sleep 2
clear
echo -e "[ ${green}INFO${NC} ] Renew cert done... " 
sleep 2
clear
echo -e "[ ${green}INFO${NC} ] Starting service $Cek " 
sleep 2
echo $domain > /etc/xray/domain
clear
systemctl restart nginx
clear
echo -e "[ ${green}INFO${NC} ] All finished... " 
clear
sleep 0.5
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
menu

}

add-host() {
clear
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Domain anda saat ini:"
echo -e "$(cat /etc/xray/domain)"
echo ""
read -rp "Domain/Host: " -e host
echo ""
if [ -z $host ]; then
echo "DONE CHANGE DOMAIN"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
read -n 1 -s -r -p "Press any key to back on menu"
menu
else
echo "$host" > /etc/xray/domain
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -n 1 -s -r -p "Press any key to renew cert"
cert1
fi
}

backup() {
# Cek apakah `curl` terpasang, lalu tambahkan `1.1.1.1` ke `/etc/resolv.conf` jika belum ada
[[ -e $(which curl) ]] && grep -q "1.1.1.1" /etc/resolv.conf || { 
    echo "nameserver 1.1.1.1" | cat - /etc/resolv.conf > /etc/resolv.conf.tmp && mv /etc/resolv.conf.tmp /etc/resolv.conf
}

# Informasi skrip dan tim pengembang
#  |=================================================================================|
#  • Autoscript AIO Lite Menu By FN Project                                          |
#  • FN Project Developer @Rerechan02 | @PR_Aiman | @farell_aditya_ardian            |
#  • Copyright 2024 18 Marc Indonesia [ Kebumen ] | [ Johor ] | [ 上海，中国 ]       |
#  |=================================================================================|

# Inisialisasi variabel
date=$(date)
domain=$(cat /etc/xray/domain)
cpt="$date / $domain"
MYIP=$(curl -s ifconfig.me)

# Proses Backup
clear
echo "Mohon Menunggu, Proses Backup sedang berlangsung!!"
rm -rf /root/backup /root/*
mkdir /root/backup
cp -r /etc/xray /root/backup/xray

# Membuat file ZIP dari backup
cd /root
zip -r backup.zip backup > /dev/null 2>&1

# Upload file ZIP ke file.io dan ambil link
random_number=$(gpg --gen-random 2 90 | tr -dc A-Za-z0-9 | sed 's/\(..\)/\1:/g; s/.$//')
file_path="/root/backup.zip"
api_url="https://file.io"
expiry_duration=$((14 * 24 * 60 * 60))
response=$(curl -s -F "file=@$file_path" -F "expiry=$expiry_duration" $api_url)
upload_link=$(echo $response | jq -r .link)
id_link=$(echo $response | jq -r .key)

# Persiapkan pesan Telegram
TEKS="
[ Information Your Backup Data ]
================================

Your ID    : $id_link
Your IP    : $MYIP
Link Backup: $upload_link
Date / Domain: $date / $domain
================================
Your File Backup AutoDelete After 7 Days
"

# Cek dan buat file backup.log jika tidak ada
if [ ! -f /etc/funny/backup.log ]; then
    touch /etc/funny/backup.log
    echo "File /etc/funny/backup.log telah dibuat."
else
    echo "File /etc/funny/backup.log sudah ada, melanjutkan perintah selanjutnya."
fi

# Menyimpan Log Backup
echo "$TEKS" >> /etc/funny/backup.log
clear

# Kirim pesan ke Telegram
CHATID=$(cat /etc/funny/.chatid)
KEY=$(cat /etc/funny/.keybot)
TIME="10"
#URL1="https://api.telegram.org/bot$KEY/sendMessage"
#curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEKS&parse_mode=html" $URL1 >/dev/null

# Kirim file backup ke Telegram
URL2="https://api.telegram.org/bot$KEY/sendDocument"
CAPTION="$TEKS"
curl -s --max-time $TIME -F chat_id=$CHATID -F document=@backup.zip -F caption="$CAPTION" $URL2

# Bersihkan file backup setelah selesai
rm -fr /root/backup*

# Output informasi backup ke layar
clear
echo "$TEKS"
echo "Please Save your Link Backup"
}

restore() {
clear
echo "This Feature Can Only Be Used According To Vps Data With This Autoscript"
echo "Please input link to your vps data backup file."
read -rp "Link File: " -e url
cd /root
wget -O backup.zip "$url"
unzip backup.zip
rm -f backup.zip
sleep 1
echo "Tengah Melakukan Backup Data"
cd /root/backup
cp -r xray /etc/

clear
cd
rm -rf /root/backup
rm -f backup.zip
clear
clear
systemctl daemon-reload
systemctl restart xray
clear
echo "Telah Berjaya Melakukan Backup"
}

menu() {
red='\e[1;31m'
green='\e[1;32m'
#pink='\e[1;35m'
NC='\e[0m'
#18. Show X-Ray Active Account on Database Server
clear
echo -e "
==============================
  [ 菜单数据 V2ray 管理器 ]
=============================="
status="$(systemctl show xray.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e "${white}V2射线 状态 ${NC}: "${green}"running"$NC" ✓"
else
echo -e "${white}V2射线 状态 ${NC}: "$red"not running (Error)"$NC" "
fi
status="$(systemctl show nginx.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e "${white}负载均衡${NC}: "${green}"running"$NC" ✓"
else
echo -e "${white}负载均衡${NC}: "$red"not running (Error)"$NC" "
fi
#V2ray 状态： $xtr
#负载均衡器： $ng
echo "
1. Create User Vmess
2. Delete User Vmess
3. Extend User Vmess
4. Cek IP Access Account
==============================
5. Change Domain
6. Renew Certificate
7. Backup Database Server
8. Restore Database Server
9. Menu Warp Wireguard Server
==============================
"
read -p "Input Option: " opw
case $opw in
1|01) add ;;
2|02) delete ;;
3|03) extend ;;
4|04) login ;;
5|05) add-host ;;
6|06) cert1 ;;
7|07) backup ;;
8|08) restore ;;
9|09) menu-warp ;;
*) menu ;;
esac
}

menu
