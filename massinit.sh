
cat logo2.txt
echo "              Dahua M@ss init script by Nudziarz 3:> "
#echo -e "\e[1;31m wcisnij klawisz by zaczac \e[0m"
#read Klawisz

#ustalanie parametrów
echo -e "\e[1;33m Podaj pierwszy adres IP (ex. 192.168.1.10)\e[0m" 
read IP
oct1=$(echo ${IP} | tr "." " " | awk '{ print $1 }')
oct2=$(echo ${IP} | tr "." " " | awk '{ print $2 }')
oct3=$(echo ${IP} | tr "." " " | awk '{ print $3 }')
oct4=$(echo ${IP} | tr "." " " | awk '{ print $4 }')
echo -e "\e[1;33m podaj koncowy adres IP (ex. 192.168.1.20) \e[0m" 
#echo -n "podaj koncowy adres IP (ex. 192.168.1.20) "
read IP2
oct6=$(echo ${IP2} | tr "." " " | awk '{ print $1 }')
oct7=$(echo ${IP2} | tr "." " " | awk '{ print $2 }')
oct8=$(echo ${IP2} | tr "." " " | awk '{ print $3 }')
oct5=$(echo ${IP2} | tr "." " " | awk '{ print $4 }')
echo -e "\e[1;33m Zakres adresów IP to : \e[1;32m $oct1.$oct2.$oct3.$oct4-$oct5 \e[0m" 
#echo "Zakres adresów IP to : $oct1.$oct2.$oct3.$oct4-$oct5 "
echo ""
echo -e "\e[1;33m Podaj adres bramy (sugeruje uzyc adresu rejestratora)  \e[0m"
read GW

#petla od adresu poczatkwego do koncowego
 for ((i = $oct4; i <= $oct5; i++)); do
    echo -e "\e[1;33m Sprawdzam czy kamera jest podpieta \e[0m"
    #printf "%s" "Sprawdzam czy kamera jest podpieta"
#polecenie do sprawdzania czy kamerka bangla
while ! httping -qc1 192.168.1.108 &> /dev/null
do 
printf "."
done
echo""
echo -e "\e[1;32m  kamera podpieta !\e[0m"
#printf "kamera podpieta !"
echo ""
#echo "poczekajmy 15 sek na wybudzenie kamery"
#sleep 10

    ip=$oct1.$oct2.$oct3.$i
    echo -e "\e[1;33m Konfiguruje adres: \e[1;32m $ip\e[0m" 
    #echo "Konfiguruje adres: $ip"
    

#init kamery na defaultowym adresie
echo -e "\e[1;33m inicjalizuje kamere \e[0m" 
#warunek sprawdzajacy wykonanie initu
if selenium-side-runner -c "browserName=firefox moz:firefoxOptions.args=[-headless]" dahua.side ; then
    echo -e "\e[1;32m Sukces !\e[0m"
else
    echo -e "\e[1;31m fail! \e[1;39m sprobujmy innej konfiguracji (niektore kamery maja problem z tłumaczeniem) \e[0m" 
    #echo "fail sprobujmy innej konfiguracji (niektore kamery maja problem z tłumaczeniem)"
   selenium-side-runner -c "browserName=firefox moz:firefoxOptions.args=[-headless]" dahuaff.side
fi
#koniec warunku
echo""
echo -e "\e[1;32m Konfiguracja karty sieciowej\e[0m"
#echo "konfiguracja adresacji:"
#set ip 
google-chrome  " http://admin:1qwerty231@192.168.1.108/cgi-bin/configManager.cgi?action=setConfig&Network.eth0.IPAddress=$ip&Network.eth0.DefaultGateway=$GW&Network.eth0.SubnetMask=255.255.255.0"
echo -e "\e[1;32m zakonczono konfiguracje kamery \e[1;33m $ip \e[0m"
echo -e "posprzatajmy przed konfiguracja !"
sleep 5
done #koniec jednej petli ?

