#!/bin/sh
# Auto Installer Bash Script

#Включаем логгирование скрипта
LOG_PIPE=log_ai.pipe
rm -f LOG_PIPE
mkfifo ${LOG_PIPE}
LOG_FILE=log_aiBash.txt
rm -f LOG_FILE
tee < ${LOG_PIPE} ${LOG_FILE} &
exec  > ${LOG_PIPE}
exec  2> ${LOG_PIPE}

__START__() {
	printf "\033[1;32m$@\033[0m"
}
Text_INFO()
{
	__START__ "$@\n"
}
Text_n()
{
	Text_INFO "- - - $@"
}
Text_SEPARATOR()
{
	Text_INFO "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
}
Text_TITLE()
{
	Text_SEPARATOR
	Text_INFO "- - - $@"
	Text_SEPARATOR
}

red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)

setup_server()
{
  clear

	Text_TITLE "• Обновляю пакеты репозиториев •"
	  apt -y update
	Text_TITLE "• Завершаю обновление репозиториев •"

	Text_TITLE "• Выполняю: apt autoremove -y•"
	  apt autoremove -y
	Text_TITLE "• Завершаю •"

	Text_TITLE "• Выполняю: apt clean •"
	  apt -y clean
	Text_TITLE "• Завершаю •"

  Text_TITLE "• Выполняю: apt -y install --fix-missing •"
	  apt -y install --fix-missing
	Text_TITLE "• Завершаю •"

	Text_TITLE "• Подготовка к установке: •"
	Text_INFO "     "

  sleep 5

  Text_TITLE "• >> Устанавливаю важные пакеты... •"
  Text_SEPARATOR

    Text_INFO "${blue}[INSTALL]:${green} sudo"
	    apt-get install -y sudo
	  Text_INFO "${blue}[COMPLECTED]:${green} sudo"

    Text_INFO

    Text_INFO "${blue}[INSTALL]:${green} apt"
	    apt-get install -y apt
	  Text_INFO "${blue}[COMPLECTED]:${green} apt"

    Text_INFO

    Text_INFO "${blue}[INSTALL]:${green} wget"
	    apt-get install -y wget
	  Text_INFO "${blue}[COMPLECTED]:${green} wget"

    Text_INFO

    Text_INFO "${blue}[INSTALL]:${green} apt-utils"
	    apt-get install -y apt-utils
	  Text_INFO "${blue}[COMPLECTED]:${green} apt-utils"

    Text_INFO

    Text_INFO "${blue}[INSTALL]:${green} software-properties-common"
	    apt-get install -y software-properties-common
	  Text_INFO "${blue}[COMPLECTED]:${green} software-properties-common"

    Text_INFO

  sleep 5

    Text_INFO

    Text_INFO "${blue}[INSTALL]:${green} pwgen"
	    apt-get install -y pwgen
	  Text_INFO "${blue}[COMPLECTED]:${green} pwgen"

    Text_INFO

    Text_INFO "${blue}[INSTALL]:${green} dialog"
	    apt-get install -y dialog
	  Text_INFO "${blue}[COMPLECTED]:${green} dialog"

    Text_INFO

    Text_INFO "${red}[INSTALL SKIPPED]:${green} python-software-properties"
	    #apt-get install -y python-software-properties
	  Text_INFO "${red}[INSTALL SKIPPED]:${green} python-software-properties"

	Text_SEPARATOR
	Text_TITLE "• Установка важных пакетов завершена. Продолжаем... •"
	sleep 5

	Text_INFO "     "

	Text_TITLE "${green}• ${red}Генерируем временные пароли для PHPMyAdmin ${green}•"
    MYPASS=$(pwgen -cns -1 20)
	  MYPASS2=$(pwgen -cns -1 20)
	Text_TITLE "• Пароли сгенерированы! •"

	Text_INFO "     "

  Text_TITLE "${green}• Записываю пароли в ${red}MySQL ${green}конфиг •"
	    echo mysql-server mysql-server/root_password select "$MYPASS" | debconf-set-selections
	    echo mysql-server mysql-server/root_password_again select "$MYPASS" | debconf-set-selections
	Text_TITLE "• ${green}Пароли записаны •"

	Text_INFO "     "

  Text_TITLE "• Устанавливаю репозитории phpmyadmin •"
    sudo add-apt-repository -y ppa:phpmyadmin/ppa
  Text_TITLE "• Репозитории добавлены •"

  sleep 3

  Text_INFO "     "

	Text_TITLE "• Устанавливаю обновления •"
	  sudo apt-get update -y
	  sudo apt-get upgrade -y
	Text_TITLE "• Завершаю обновление •"
	clear

	Text_INFO "     "

  Text_TITLE "• Устанавливаю пакет php7.4-cli •"
  	sudo apt-get install -y php7.4-cli
  Text_TITLE "• Установка php7.4-cli завершена •"
  sleep 5
  clear

  Text_INFO "     "

  Text_TITLE "• Устанавливаю Python •"
    Text_INFO "${blue}[INSTALL]:${green} python-pip"
	    apt-get install -y python-pip
	  Text_INFO "${blue}[COMPLECTED]:${green} python-pip"

    Text_INFO

    Text_INFO "${blue}[INSTALL]:${green} python"
	    apt-get install -y python
	  Text_INFO "${blue}[COMPLECTED]:${green} python"

    Text_INFO

    Text_INFO "${blue}[INSTALL]:${green} python3"
	    apt-get install -y python3
	  Text_INFO "${blue}[COMPLECTED]:${green} python3"
	  Text_TITLE "• Установка Python завершена •"
	  sleep 2
	  clear

  Text_TITLE "• Устанавливаю приложения •"

    Text_INFO "${blue}[INSTALL]:${green} apache2"
	    apt-get install -y apache2
	  Text_INFO "${blue}[COMPLECTED]:${green} apache2"

    Text_INFO

    Text_INFO "${blue}[INSTALL]:${green} php-cli"
	    apt-get install -y php-cli
	  Text_INFO "${blue}[COMPLECTED]:${green} php-cli"

    Text_INFO

    Text_INFO "${blue}[INSTALL]:${green} libapache2-mod-php"
	    apt-get install -y php-dev
	  Text_INFO "${blue}[COMPLECTED]:${green} libapache2-mod-php"

    Text_INFO

    Text_INFO "${blue}[INSTALL]:${green} unzip"
	    apt-get install -y unzip
	  Text_INFO "${blue}[COMPLECTED]:${green} unzip"

    Text_INFO

    Text_INFO "${blue}[INSTALL]:${green} mysql-server"
	    apt-get install -y mysql-server
	  Text_INFO "${blue}[COMPLECTED]:${green} mysql-server"

    Text_INFO

    Text_INFO "${blue}[INSTALL]:${green} mysql-client"
	    apt-get install -y mysql-client
	  Text_INFO "${blue}[COMPLECTED]:${green} mysql-client"

    Text_INFO

    Text_INFO "${blue}[INSTALL]:${green} php-json"
	    apt-get install -y php-json
	  Text_INFO "${blue}[COMPLECTED]:${green} php-json"

    Text_INFO

    Text_INFO "${blue}[INSTALL]:${green} php-curl"
	    apt-get install -y php-curl
	  Text_INFO "${blue}[COMPLECTED]:${green} php-curl"

	Text_TITLE "• Приложения установлены •"
	sleep 5
	clear

	Text_TITLE "${green}• Вношу изменения в ${red}PHPMyAdmin ${green}•"
	  echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
	  echo "phpmyadmin phpmyadmin/mysql/admin-user string root" | debconf-set-selections
	  echo "phpmyadmin phpmyadmin/mysql/admin-pass password $MYPASS" | debconf-set-selections
	  echo "phpmyadmin phpmyadmin/mysql/app-pass password $MYPASS" |debconf-set-selections
	  echo "phpmyadmin phpmyadmin/app-password-confirm password $MYPASS" | debconf-set-selections
	  echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections
	Text_TITLE "• ${red}PHPMyAdmin настроен! •"

	Text_INFO "     "

	Text_TITLE "• Подготовка: •"
	Text_TITLE "• >> Устанавливаю пакеты: ${yellow}phpmyadmin"
	  sudo apt-get install -y phpmyadmin
	Text_TITLE "• >> Выполнена команда установки пакета:${yellow} phpmyadmin"

	Text_INFO "     "

	Text_TITLE "• Настраиваю Apache сервер •"
	  STRING=$(apache2 -v | grep Apache/2.4)
	Text_TITLE "• Apache настроен •"

	Text_INFO "     "

  Text_TITLE "• Вношу изменения в файл конфигурации сервера •"
	if [ "$STRING" = "" ]; then
		FILE='/etc/apache2/conf.d/aiBash'
		echo "<VirtualHost *:80>">$FILE
		echo "ServerName $DOMAIN">>$FILE
		echo "DocumentRoot $INSTALL_DIR">>$FILE
		echo "<Directory $INSTALL_DIR/>">>$FILE
		echo "Options Indexes FollowSymLinks MultiViews">>$FILE
		echo "AllowOverride All">>$FILE
		echo "Order allow,deny">>$FILE
		echo "allow from all">>$FILE
		echo "</Directory>">>$FILE
		echo "ErrorLog \${APACHE_LOG_DIR}/error.log">>$FILE
		echo "LogLevel warn">>$FILE
		echo "CustomLog \${APACHE_LOG_DIR}/access.log combined">>$FILE
		echo "</VirtualHost>">>$FILE
	else
		FILE='/etc/apache2/conf-enabled/aiBash.conf'
		cd /etc/apache2/sites-available
		sed -i "/Listen 80/d" *
		cd ~
		echo "Listen 80">$FILE
		echo "<VirtualHost *:80>">$FILE
		echo "ServerName $DOMAIN">>$FILE
		echo "DocumentRoot $INSTALL_DIR">>$FILE
		echo "<Directory $INSTALL_DIR/>">>$FILE
		echo "AllowOverride All">>$FILE
		echo "Require all granted">>$FILE
		echo "</Directory>">>$FILE
		echo "ErrorLog \${APACHE_LOG_DIR}/error.log">>$FILE
		echo "LogLevel warn">>$FILE
		echo "CustomLog \${APACHE_LOG_DIR}/access.log combined">>$FILE
		echo "</VirtualHost>">>$FILE
	fi
	Text_TITLE "• Конфигурация внесена •"

	Text_INFO "     "

	Text_TITLE "• Выполнение команд: •"
	Text_n "•  >> a2enmod rewrite •"
	  a2enmod rewrite
	Text_n "•  >> a2enmod php*.* •"
	  a2enmod php*.*
	Text_n "•  >> /etc/init.d/apache2 restart •"
	/etc/init.d/apache2 restart
	Text_n "•  >> service apache2 restart •"
	  service apache2 restart
	Text_n "•  >> cd ~ •"
    cd ~
	Text_TITLE "• Выполнение команд завершено •"
	sleep 3

	Text_INFO "     "

  Text_TITLE "• • Создаю, подключаю и очищаю каталог, где будет хранится сайт: ${red}$INSTALL_DIR${green} • •"
	  mkdir $INSTALL_DIR/
	  sudo chmod 777 /$INSTALL_DIR
	  cd $INSTALL_DIR/
	  rm -Rfv *
	Text_TITLE "• Каталог создан •"

	Text_INFO "     "

  Text_TITLE "• • Теперь создаю тестовый файл index.php • •"
    echo "<?php phpinfo(); ?>" > index.php
    Text_TITLE "• • Выдаю права 777. Измените обязательно! • •"
    sudo chmod 777 ./*
  Text_n "•  Тестовый файл создан •"
  sleep 3

  Text_INFO "     "

	Text_n "•  Возвращаемся в домашний каталог •"
	  cd ~
	Text_n "• Продолжаем... •"

	Text_INFO "     "

  Text_TITLE "${green}• • Задаю часовой пояс Москвы • •"
	  Text_n "${green}•  >> ${yellow}Europe/Moscow ${green}в ${yellow}/etc/timezone ${green}•"
	    echo "Europe/Moscow" > /etc/timezone
	      dpkg-reconfigure tzdata -f noninteractive
	    Text_n "${green}•  >> Update: ${yellow}/etc/php/*.*/cli/php.ini ${green}•"
        sudo sed -i -r 's~^;date\.timezone =$~date.timezone = "Europe/Moscow"~' /etc/php/*.*/cli/php.ini
	    Text_n "${green}•  >> Update: ${yellow}/etc/php/*.*/apache2/php.ini ${green}•"
        sudo sed -i -r 's~^;date\.timezone =$~date.timezone = "Europe/Moscow"~' /etc/php/*.*/apache2/php.ini
	  Text_INFO
	Text_TITLE "${red}• ГОТОВО! •"
	Text_INFO
	sleep 5

	Text_INFO "     "

	Text_TITLE "• Обновляю пакеты репозиториев •"
	sudo apt-get update -y
	Text_TITLE "• Завершаю обновление репозиториев •"

	Text_INFO "     "

	Text_TITLE "• Перезапускаю модули Apache и MySQL •"
	service apache2 restart
	service mysql restart
	Text_TITLE "• Команды перезапуска выполнены •"
	sleep 5

	clear
	Text_SEPARATOR
	Text_INFO "${red}Пожалуйста, оцените работу скрипта! ${yellow}https://clck.ru/N9mux"
	Text_INFO
		Text_TITLE "${green}• • t.me/${red}MiKillCrafter ${green}• •"
	  Text_TITLE "${green}• • ${blue}https://MKC-MKC.GitHub.IO"
	  Text_SEPARATOR
		Text_n "${red}Сайт установлен по этому пути:"
    Text_n "${blue}$INSTALL_DIR"
      Text_INFO
        Text_n "${yellow}http://$DOMAIN/${red}phpmyadmin"
      Text_INFO
		Text_n "${red}Логин${green}: ${yellow}root"
		Text_n "${red}Пароль${green}: ${yellow}$MYPASS"
		Text_INFO
		Text_SEPARATOR
	Text_INFO
	Text_TITLE "• Всё готово [All done]•"
	  Text_INFO "1 – Установить бесплатный SSL [Install free SSL]"
	  Text_INFO "2 – Меню [Menu]"
	  Text_INFO "0 – Выход [Exit]"
	Text_INFO
	read -p "Введи 0 чтобы завершить: " case
	case $case in
	  1) installCertificate;;
	  2) menu;;
	  0) exit;;
	esac
}

installCertificate()
{
	Text_TITLE "• Обновляю пакеты репозиториев •"
	  apt-get update -y
	Text_TITLE "• Завершаю обновление репозиториев •"

	Text_TITLE "• Добавляю репозиторий universe •"
	  add-apt-repository -y universe
	Text_TITLE "• Репозиторий успешно добавлен •"

	Text_TITLE "• Добавляю репозиторий certbot •"
	  sudo add-apt-repository -y ppa:certbot/certbot
	Text_TITLE "• Репозиторий успешно добавлен •"

	Text_TITLE "• Устанавливаю software-properties-common •"
	  apt-get install -y software-properties-common
	Text_TITLE "• Репозиторий успешно добавлен •"

	Text_TITLE "• Устанавливаю certbot && python-certbot-apache •"
	  apt-get install -y certbot python-certbot-apache
	Text_TITLE "• Репозиторий успешно добавлен •"

	Text_TITLE "• Устанавливаем только сертификат для Apache •"
	  sudo certbot certonly --webroot -w $INSTALL_DIR -d $DOMAIN -d www.$DOMAIN
	Text_TITLE "• Сертификат установлен •"
	clear

	Text_TITLE "• [Ручная установка №1]: Введите публичный Email для аккаунта ACME и пройдите опрос •"
	Text_INFO "${red}НАПОМИНАНИЕ:"
	Text_INFO "${red}Сайт установлен по этому пути: ${blue}$INSTALL_DIR"
	Text_INFO "${red}Ваш адрес сайта: ${yellow}http://$DOMAIN"
	sleep 10
	  sudo certbot certonly --standalone -d $DOMAIN -d www.$DOMAIN
	  Text_INFO "Если всё прошло успешно, сертификат тут: /etc/letsencrypt/live/$DOMAIN/"
	Text_TITLE "• [Ручная установка №1]: Завершена •"

	Text_TITLE "• Создаю сертификат •"
	  Text_INFO "Введите цифру нужного домена или несколько цифр, разделённых запятой."
	  Text_INFO "Утилита сама установит всё, что нужно, а затем спросит вас,"
	  Text_INFO "нужно ли перенаправлять http-трафик на https:"
	  sleep 10
	  sudo certbot run --apache
	Text_TITLE "• Сертификат создан •"

	Text_TITLE "• Обновляю сертификат •"
	  sudo certbot certonly --apache -n -d $DOMAIN -d www.$DOMAIN
	Text_TITLE "• Обновление заверено •"

	Text_TITLE "${green}• Выполнение: ${blue}certbot renew --dry-run ${green}запушено: •"
	  sudo certbot renew --dry-run
	Text_TITLE "${green}• Выполнение: ${blue}certbot renew --dry-run ${green}завершено •"
	clear
	Text_INFO "${green}Installation complected"
	menu
}

updateCertificate()
{
  Text_SEPARATOR
	Text_TITLE "• Update cert only •"
	  sudo certbot certonly --apache -n -d $DOMAIN -d www.$DOMAIN
	  sudo certbot renew
	  #sudo certbot renew --dry-run
	Text_SEPARATOR
	clear
	Text_TITLE "• Обновление заверено •"
	menu
}

menu()
{
		Text_SEPARATOR
		Text_INFO "${red}Пожалуйста, оцените работу скрипта!"
		Text_INFO "• ${blue}Menu:"
		  Text_INFO "${green}• - 1 – Настроить сервер [Setup server]"
		  Text_INFO "${green}• - 2 – ${red}[beta] ${green}Установить бесплатный SSL [Install free SSL]"
		  Text_INFO "${green}• - 3 – ${red}[beta] ${green}Обновить истёкший SSL сертификат [Update an expired SSL certificate]"
		  Text_INFO "${green}• - 4 – Вернутся чтобы изменить IP-адрес или папку для сайта [Back for change IP or folder for the site]"
		  Text_INFO
		  Text_INFO "${red}• - 0 – Выход [Exit]"
		Text_SEPARATOR
		Text_INFO "${blue}What u choose?: "
		read -p "${blue}Что ты выбираешь?: " case
		case $case in
			1) setup_server;;
			2) installCertificate;;
			3) updateCertificate;;
			4) InputArrayData;;
			0) exit;;
	esac
}

InputArrayData()
{
	clear
	Text_INFO "${blue}[Инфо]${green}: Введите путь к папке с сайтом"
	Text_INFO "${blue}[INFO]${green}: Enter the path to the directory with the site"
	Text_INFO
	Text_INFO "${green}• (Пример | Example): ${yellow}/var/www ${green}"
	Text_INFO
	read -p "${green}Введи путь до сайта:${yellow} " INSTALL_DIR
	clear
	sudo ifconfig
	Text_INFO "${green}Enter ${red}domain ${green}or ${red}IP:"
	read -p "${green}Введи ${red}домен ${green}или ${red}IP:${green} " DOMAIN
	clear
	menu
}

start()
{
	clear
	if [ "$USER" = "root" ]; then
		Text_SEPARATOR
		Text_INFO
		Text_INFO "• [Apache2] ${blue}Ты точно хочешь запустить настройку Ubuntu сервера?"
		Text_INFO "• [Apache2] ${blue}Are you sure you want to start setting up the Ubuntu server?"
		Text_INFO
		  Text_INFO "${green}• - 1 - ДА – YES ✔ •"
		  Text_INFO "${red}• - 0 - НЕT – NO ✔ •"
		Text_INFO
		Text_SEPARATOR
		Text_INFO "${blue}Want to continue? (Input: ${green}1 or ${red}0${blue}): "
		read -p "${blue}Хотите продолжить? (Введи: ${green}1 или ${red}0${blue}): " case
		case $case in
			1) InputArrayData;;
			0) exit;;
		esac; clear
	else clear; Text_INFO "${red}You are not a root | Вы не root"; fi
}

start