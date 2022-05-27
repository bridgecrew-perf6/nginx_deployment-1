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
