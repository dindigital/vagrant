echo "----> Iniciando Configuração"

echo "----> Atualizando Linux"
sudo cp /vagrant/files/sources.list /etc/apt/sources.list
apt-get update

echo "----> Upgrade Dist"
apt-get dist-upgrade -y

echo "----> Instalando apache"
apt-get install apache2 -y
a2enmod rewrite

echo "----> Instando o PHP"
apt-get install php5 libapache2-mod-php5 php5-mcrypt -y
apt-get install php5-cli -y

echo "----> Instando o PERCL"
apt-get install python-software-properties php5-dev -y

echo "----> Instando o CURL"
apt-get install php5-curl -y

echo "----> Instando o MYSQL"
apt-get -y install mysql-server php5-mysql -y

echo "----> Instando o Memcached"
apt-get install php5-memcached memcached -y

echo "----> Instando o APC"
pecl install apc

echo "----> Instando composer"
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

echo "----> Instando GIT"
apt-get install git-core -y
apt-get install libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev build-essential -y

echo "----> Adicionando diretorio de Vhosts" 
rm -rf /etc/apache2/sites-enabled
ln -fs /vagrant/files/vhosts /etc/apache2/sites-enabled

echo "----> Adicionando diretorio de WWW" 
rm -rf /var/www
ln -fs /vagrant/web /var/www

echo "----> Instando dependencias" 
apt-get -f install -y 

echo "----> Reiniciando apache" 
service apache2 restart

echo "----> Instalação finalizada !!!"