echo "----> Iniciando Configuração"

echo "----> Arruma diferença de LOCALE entre o terminal do MAC e o terminal da VM"
echo 'LC_ALL="en_US.UTF-8"' >> /etc/environment

echo "----> Atualizando Linux"
apt-get update && apt-get dist-upgrade

echo "----> Instalando apache"
apt-get install apache2 -y
a2enmod rewrite

echo "----> Instando o PHP"
apt-get install php5 libapache2-mod-php5 php5-mcrypt php5-cli -y
cp ./files/php.ini /etc/php5/apache2/php.ini -R

echo "----> Instando o PECL"
apt-get install python-software-properties php5-dev -y

echo "----> Instando o CURL"
apt-get install curl php5-curl -y

echo "----> Instando o XDEBUG"
pecl install xdebug

echo "----> Instando GD"
apt-get install php5-gd -y

echo "----> Instando o MYSQL"
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password mysql'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password mysql'
apt-get -y install mysql-server php5-mysql -y

echo "----> Arruma privilegios MYSQL"
cp ./files/my.cnf /etc/mysql/my.cnf -R
service mysql restart
mysql -uroot -pmysql -e "DELETE FROM mysql.user WHERE User='root' AND Host='127.0.0.1';
DELETE FROM mysql.user WHERE User='root' AND Host='::1';
UPDATE mysql.user SET Host='%' WHERE Host='localhost' AND User='root';
FLUSH PRIVILEGES;"

echo "----> Instando o Memcached"
# apt-get install php5-memcached memcached -y

echo "----> Instando o APC"
# pecl install apc

echo "----> Instando composer"
curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=/bin

echo "----> Instando GIT"
apt-get install git -y

echo "----> Adicionando diretorio de Vhosts" 
rm -rf /etc/apache2/sites-enabled
ln -fs /vagrant/files/vhosts /etc/apache2/sites-enabled

echo "----> Copia PHP INFO"
cp ./web/info /var/www -R

echo "----> Reiniciando apache" 
service apache2 restart

echo "----> Instalação finalizada !!!"
