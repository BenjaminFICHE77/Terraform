amazon-linux-extras install epel -y
yum install certbot python2-certbot-apache -y
certbot --apache --non-interactive --agree-tos -m benjamin.f@datascientest.com --redirect -d $dns_host.com
(sudo crontab -l 2>/dev/null; echo "0 0 1 * * certbot renew") | sudo crontab -