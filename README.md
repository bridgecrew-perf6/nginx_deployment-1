# Website Hosting simple and with IAC
This is a way to install and set up Nginx, on Ubuntu 20.04.
#### A. First we will do it manually
#### B. Than we will use bash script for whole process.

## A. Manual website Hosting

	Following things must be installed and running to implement this project
	Host Machine:			Macbook
	Virtualization Platform: 	VMWare Fusion 12.3
	Virtual Machine:		Ubuntu 20.04
	Web Server:			Nginx

Follow this link for help,
How to Install Ubuntu 20.04 on a Mac using VirtualBox
```
https://medium.com/tech-lounge/how-to-install-ubuntu-on-mac-using-virtualbox-3a26515aa869
```

Follow this link  for help, 
Nginx installation on ubuntu 20.04
```
https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-20-04
```

 1. Install Oracle VirtualBox.dmg file on your OS X
 2. Create Ubuntu-server-20.04 VM inside VirtualBox

	i. Install openssh server on ubuntu vm	
	
		# apt install openssh-server 
		
	ii. View status of server 	
			
		# systemctl status ssh
		
	iii. Allow port 22 in ufw for ssh		
		
		# sudo ufw allow ssh
	
	iv. Open ssh configuration file and add following switch
		File path: /etc/ssh/sshd_config
		
		PermitRootLogin yes
			
	v. To access mac OS remotely, open terminal and type
		
		# sudo ssh root@ubuntu_ip

3. Update your ubuntu VM				
		
		# apt-get update -y

4. Install nginx server					
		
		# apt-get install nginx -y

	Some important commands you may need:

	View version									
			
		# nginx -v

	View nginx status								
		
		# systemctl status nginx
	
	Enable nginx on startup							
		
		# systemctl enable nginx
	
	Restart nginx 									
		
		# systemctl restart nginx

5. Enable nginx via ufw(Ubuntu Firewall)
	Enable ufw					 									
		
		# ufw enable

	View available nginx profiles			 									
		
		# ufw app list

	Allow nginx profiles via ufw			 									
		
		# ufw allow ‘nginx http’
		# ufw allow ‘nginx https’
		
	Restart ufw to update rules edited		 									
		
		# ufw reload
		
6. Verify that base OS is connected(LAN) with ubuntu vm

		# ping host OS ip

7. Test nginx response on terminal			

		# curl -i 127.0.0.1

8. Test nginx response on base OS via browser	
	> 	Hint:	Enter ip of ubuntu vm in your browser it’ll load nginx welcome page 

9. Host a website on your nginx server by Configuring a Server Block

	i. Make directory for your website			

		# mkdir -p /var/www/test_domain.com/html

	> Note: Move your website in this directory

	ii. Configure Ownership and Permissions			

		# chown -R $USER:$USER /var/www/test_domain.com
		# chmod -R 755 /var/www/test_domain.com			
		
	iii. Download your website in the directory test_domain.com	

		# git clone <url/> <target_folder/>

	> Hint: git clone https://github.com/arvind37/Basic-Website-using-HTML-CSS/ /var/www/test_domain.com/


	iv. Move to directory		
		
		# cd /etc/nginx/sites-available

	v. Copy default server block as test_domain.com		
		
		# cp default test_domain.com

	vi. Open and edit server block as follows:

		# vim test_domain.com
	
	Add following configuration in your file
	```
		 server {
			listen 80;
			listen [::]:80;
			root /var/www/test_domain.com/;
			index index.html index.htm index.nginx-debian.html;
			server_name test_domain.com www.test_domain.com;
			location / {
			}
		    }
	```

  	vii. Create Symbolic Link for Nginx to link website flagging it as active and accessible

		# ln -s /etc/nginx/sites-available/test_domain.com /etc/nginx/sites-enabled

	viii. Restart nginx				

		# sudo systemctl restart nginx

	ix. Test the Configuration			

		# nginx -t

	x. Modify the Hosts File and Add following line:  

	x. Open Hosts file and add create following entry:  
		
		# vim /etc/hosts

>		Note: sample: ubuntu_IP test_domain.com www.test_domain.com
	
10. Now open 'hosts' file and add create following entry:			

		# vim /etc/hosts
		
>		Note: sample: ubuntu_IP test_domain.com www.test_domain.com

> 	Note: This is necessary so that host OS will go to the given ip to resolve web address which is in my case test_web.com

11. Now goto your brower on host OS and enter test_domain.com
	Your hosted website will be up and running.
	

## B. Hosting Via Bash(IaaC)

1. Create bash file					

		# touch /root/nginx_script.sh

2. Allow permissions					
	
		# chmod u+x nginx_script.sh

3. Paste following script inside nginx_script.sh

```
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
		echo "Congrats Now test your website - Deployment is Successful”
```
4. To run the code:					

		# bash nginx_script.sh

>	Note: You will be prompted upon firewall enabling if you are running this script remotely, press ‘y’ on prompt.The prompt is for confirmation if the connection gets interrupted so we allow it to enable the firewall even if it gets disconnected.
