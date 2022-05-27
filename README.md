# Website Hosting simple and with IAC
This is a way to install and set up Nginx, on Ubuntu 20.04.
## A. First we will do it manually
## B. Than we will use bash script for whole process.

## A. Manual website Hosting

> Note:
Ubuntu Installation
Host Machine:				Macbook
Virtualization Platform: 	VMWare Fusion 12.3
Virtual Machine:			Ubuntu 20.04
Web Server:					Nginx

Follow this link to check,
How to Install Ubuntu 20.04 on a Mac using VirtualBox
```
https://medium.com/tech-lounge/how-to-install-ubuntu-on-mac-using-virtualbox-3a26515aa869
```

Follow this link to check, nginx installation on ubuntu 20.04
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
		#ufw allow ‘nginx https’
		
	Restart ufw to update rules edited		 									
		
		#ufw reload
