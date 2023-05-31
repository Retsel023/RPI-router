#!/bin/bash
#updates
echo "Preparing Updates..."
apt update && apt upgrade -y
apt autoremove -y
echo "Done Updating!"

#installs
echo "Preparing Installation items..."
#apt install git hostapd dnsmasq
apt install git dnsmasq

#git
git clone https://github.com/Retsel023/RPI-router.git
cd RPI-router

#hostapd.conf
#echo "Hostapd configuration preparation..."
#yes | cp -rf hostapd.conf /etc/hostapd/hostapd.conf
#systemctl unmask hostapd
#systemctl enable hostapd
#systemctl start hostapd

echo "Dnsmasq configuration preparation..."
yes | cp -rf dnsmasq.conf /etc/dnsmasq.conf

echo "dhcpcd configuration preparation..."
yes | cp -rf dhcpcd.conf /etc/dhcpcd.conf

#ipv4 forwarding
yes | cp -rf sysctl.conf /etc/sysctl.conf
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

################
### iptables ###
################
iptables -A INPUT -i eth0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth0 -j DROP
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
#iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 443 -j DNAT --to-destination 192.168.1.2:443
#iptables -t nat -A PREROUTING -i eth0 -p udp --dport 51820 -j DNAT --to-destination 192.168.1.2:51820

sh -c "iptables-save > /etc/iptables.ipv4.nat"

#rc.local
echo "Creating the rc.local config..."
touch /etc/rc.local
touch /etc/systemd/system/rc-local.service
printf '%s\n' '[Unit]' 'Description=/etc/rc.local Compatibillity' 'ConditionPathExists=/etc/rc.local' '' '[Service]' 'Type=forking' 'ExecStart=/etc/rc.local start' 'TimeoutSec=0' 'StandardOutput=tty' 'RemainAfterExit=yes' 'SysVStartPriority=99' '' '[Install]' 'WantedBy=multi-user.target' | sudo tee /etc/systemd/system/rc-local.service
printf '%s\n' '#!/bin/bash' 'iptables-restore < /etc/iptables.ipv4.nat' 'sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"' 'exit 0' | sudo tee /etc/rc.local
chmod +x /etc/rc.local
systemctl unmask rc-local
systemctl enable rc-local
systemctl start rc-local

echo "Done!"
echo "Rebooting"
reboot
