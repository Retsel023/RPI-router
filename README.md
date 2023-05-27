# RPI-router
Please note that this script has not been tested. I have writen this script based on my own assumptions and previus scripts.

The script is writen for pi os and a raspberry pi 4 with one extra ehternet port. The script can be run without this interface to and wont have any consequences but it is based on my situation.

personaly i do not use the wlan of my pi and only use the 2 phisical ethernet ports it has equiped. eth0 is the wan port in this cenario and eth1 is my ethernet adapter.

The script might need tweaking as for i have stated bofore it hasn't been tested.

If you are using ubuntu instead of pi os, you might want to look at my other project called FYS. In that project the pi uses ubuntu and is setup as a wifi accesspoint and captiveportal. This has fixes for dnsmasq/resolve.d errors and it uses netplan to set static ip as for that is ubuntu default. Note that the fys project is a school project and may have some settings you probably dont want like the sshd_config or cetain settings from fys.conf and dnsmasq.conf. (fys.conf contains the settings of the webserver).
