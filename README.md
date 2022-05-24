Website Hosting simple and with IAC
Ubuntu Installation
Host Machine:			macbook
Virtualization Platform: 	VMWare Fusion 12.3
Virtual Machine:		Ubuntu 20.04
Web Server:			nginx

Simple Hosting

Install VMWareFusion12.3.dmg file on your OS X
Create Ubuntu-server-20.04 VM inside VMWare Fusion
Create root user  				$sudo passwd root
Login to root user				$su -
View ubuntu OS details 			#lsb_release -a

 	2.1. Remote login ubuntu via ssh on Mac OS X
i. Install openssh server on ubuntu vm	#apt install openssh-server 
ii. View status of server 			#systemctl status ssh
iii. Allow port 22 in ufw for ssh		#sudo ufw allow ssh
iv. Open ssh configuration file and add following switch
File path: /etc/ssh/sshd_config
		PermitRootLogin yes
v. To access mac OS remotely, open terminal and type
	#sudo ssh root@ubuntu_ip

 
Update your ubuntu VM				#apt-get update -y
Install nginx server					#apt-get install nginx -y
View version					#nginx -v
View nginx status				#systemctl status nginx
Enable nginx on startup			#systemctl enable nginx
Restart nginx 					#systemctl restart nginx

Enable nginx via ufw(Ubuntu Firewall)
Enable ufw					#ufw enable
View available nginx profiles			#ufw app list
Allow nginx profiles via ufw			#ufw allow ‘nginx http’
			#ufw allow ‘nginx https’
Restart ufw to update rules edited		#ufw reload
Verify that base OS is connected(LAN) with ubuntu vm
#ping host OS ip

Test nginx response on terminal			#curl -i 127.0.0.1
Test nginx response on base OS via browser	
=> enter ip of ubuntu vm in your browser it’ll load nginx welcome page 
Host a website on your nginx server
Configure a Server Block
Make directory for your website
#mkdir -p /var/www/test_domain.com/html
Note: Move your website in this directory
Configure Ownership and Permissions
		#chown -R $USER:$USER /var/www/test_domain.com
#chmod -R 755 /var/www/test_domain.com
Download your website in the directory test_domain.com
For git		#git clone <url/> <target_folder/>
Move to directory		#cd /etc/nginx/sites-available
Copy default server block as test_domain.com
#cp default test_domain.com
Open and edit server block as follows:
					#vim test_domain.com
Add following configuration in your file
server {
        listen 80;
        listen [::]:80;
        root /var/www/test_domain.com/;
        index index.html index.htm index.nginx-debian.html;
        server_name test_domain.com www.test_domain.com;
        location / {
        }
    }
 Create Symbolic Link for Nginx to link website flagging it as active and accessible
#ln -s /etc/nginx/sites-available/test_domain.com /etc/nginx/sites-enabled
Restart nginx				#sudo systemctl restart nginx
Test the Configuration			#nginx -t
Modify the Hosts File			#vim /etc/hosts
			Add following line:  ubuntu_ip test_domain.com www.test_domain.com
Now on mac OS modify the Hosts File			#vim /etc/hosts
			add following line:  ubuntu_ip test_domain.com www.test_domain.com
=> This is necessary so that host OS will go to the given ip to resolve web address which is in my case test_web.com

2. Hosting Via Bash(IaaC)
Create bash file					#touch /root/nginx_script.sh
Allow permissions					#chmod u+x nginx_script.sh
Paste following script inside nginx_script.sh
Script:

#! usr/bin/bash
apt-get update -y
apt-get install nginx -y
nginx -v
systemctl enable nginx
curl -i 127.0.0.1
ufw enable
ufw allow 'nginx Full'
ufw reload
mkdir -p /var/www/test_domain.com/
chown -R $USER:$USER /var/www/test_domain.com/
chmod -R 755 /var/www/test_domain.com/
git clone https://github.com/arvind37/Basic-Website-using-HTML-CSS/ /var/www/test_domain.com/
echo "server {
        listen 80;
        listen [::]:80;
        root /var/www/test_domain.com/;
        index index.html index.htm index.nginx-debian.html;
        server_name test_domain.com www.test_domain.com;
        location / {
        }
    }" >> /etc/nginx/sites-available/test_domain.com
ln -s /etc/nginx/sites-available/test_domain.com /etc/nginx/sites-enabled
sudo systemctl restart nginx
cat <<< "10.4.106.83 test_domain.com www.test_domain.com # $(cat /etc/hosts)" > /etc/hosts
echo "Test your website Bro - Deployment Successful”

To run the code:					#bash nginx_script.sh
Note: You will be prompted upon firewall enabling if you are running this script remotely, press ‘y’ on prompt.
The prompt is for confirmation if the connection gets interrupted so we allow it to enable the firewall even if it gets disconnected.
