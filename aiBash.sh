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
	# shellcheck disable=SC2059
	# shellcheck disable=SC2145
	printf "\033[1;32m$@\033[0m"
}
Text_INFO()
{
	# shellcheck disable=SC2145
	__START__ "$@\n"
}
Text_n()
{
	# shellcheck disable=SC2145
	Text_INFO "- - - $@"
}
Text_SEPARATOR()
{
	Text_INFO "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
}
Text_TITLE()
{
	Text_SEPARATOR
	# shellcheck disable=SC2145
	Text_INFO "- - - $@"
	Text_SEPARATOR
}

red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)

start_script()
{
  clear
	# shellcheck disable=SC2162
	# shellcheck disable=SC2039
	Text_INFO "${blue}[Инфо]${green}: Введите путь к будущему каталогу с сайтом"
	Text_INFO "${blue}[INFO]${green}: Enter the path for the future directory with the site"
	Text_INFO
	Text_INFO "${green}• (Пример | Example): ${yellow}/var/www ${green}"
	Text_INFO
	read -p "${green}Введи новый путь до сайта:${yellow} " INSTALL_DIR
	clear
	Text_INFO "${green}Enter ${red}domain ${green}or ${red}IP:${green}"
	read -p "${green}Введи ${red}домен ${green}или ${red}IP:${green} " DOMAIN
	clear

	Text_TITLE "• Обновляю пакеты репозиториев •"
	  apt-get update -y
	Text_TITLE "• Завершаю обновление репозиториев •"

	Text_TITLE "• Подготовка OS к установке : •"
	Text_TITLE "• •"
    Text_TITLE "• >> Устанавливаю важные пакеты... •"
	apt-get install -y sudo wget apt-utils software-properties-common pwgen dialog #python-software-properties
	Text_TITLE "• Подготовка завершена. Продолжаем... •"

	Text_TITLE "• •"

	Text_TITLE "${green}• ${red}Генерируем временные пароли для PHPMyAdmin${green}•"
    MYPASS=$(pwgen -cns -1 20)
	  # shellcheck disable=SC2034
	Text_TITLE "• Пароли сгенерированы! •"

	Text_TITLE "• •"

	Text_TITLE "• Обновляю пакеты репозиториев •"
	  sudo apt-get upgrade -y
	Text_TITLE "• Завершаю обновление •"

	Text_TITLE "• •"

  Text_TITLE "${green}• Записываю пароли в ${red}MySQL ${green}конфиг •"
	    echo mysql-server mysql-server/root_password select "$MYPASS" | debconf-set-selections
	    echo mysql-server mysql-server/root_password_again select "$MYPASS" | debconf-set-selections
	Text_TITLE "• ${green}Пароли записаны •"

	Text_TITLE "• •"

  Text_TITLE "• Устанавливаю репозитории •"
    sudo add-apt-repository -y ppa:phpmyadmin/ppa
  Text_TITLE "• Репозитории добавлены •"

  Text_TITLE "• •"

  Text_TITLE "• Устанавливаю PHP7.2 •"
  	sudo apt-get install -y php7.2-cli
  Text_TITLE "• Установка PHP завершена •"

  Text_TITLE "• •"

  Text_TITLE "• Устанавливаю пакеты: python-pip python python3 •"
  	sudo apt-get install -y python-pip python python3
  Text_TITLE "• Установка Python завершена •"

  Text_TITLE "• •"

  Text_TITLE "• Устанавливаю приложения •"
	  sudo apt-get install -y apache2 php-cli php-dev libapache2-mod-php unzip mysql-server mysql-client php-json php-curl
	Text_TITLE "• Приложения установлены •"

	Text_TITLE "• •"

	Text_TITLE "${green}• Вношу изменения в ${red}PHPMyAdmin ${green}•"
	  echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
	  echo "phpmyadmin phpmyadmin/mysql/admin-user string root" | debconf-set-selections
	  echo "phpmyadmin phpmyadmin/mysql/admin-pass password $MYPASS" | debconf-set-selections
	  echo "phpmyadmin phpmyadmin/mysql/app-pass password $MYPASS" |debconf-set-selections
	  echo "phpmyadmin phpmyadmin/app-password-confirm password $MYPASS" | debconf-set-selections
	  echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections
	Text_TITLE "• ${red}PHPMyAdmin настроен! •"

	Text_TITLE "• •"

	Text_TITLE "• Подготовка: •"
	Text_TITLE "• >> Устанавливаю пакеты: ${yellow}phpmyadmin •"
	  sudo apt-get install -y phpmyadmin
	Text_TITLE "• Команда установк PHPMyAdmin выполнена •"

	Text_TITLE "• •"

	Text_TITLE "• Настраиваю Apache сервер •"
	  STRING=$(apache2 -v | grep Apache/2.4)
	Text_TITLE "• Apache настроен •"

	Text_TITLE "• •"

  Text_TITLE "• Вношу изменения в файл конфигурации сервера •"
	if [ "$STRING" = "" ]; then
		FILE='/etc/apache2/conf.d/aiBash'
		echo "<VirtualHost *:80>">$FILE
		# shellcheck disable=SC2129
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
		# shellcheck disable=SC2164
		cd /etc/apache2/sites-available
		# shellcheck disable=SC2035
		sed -i "/Listen 80/d" *
		# shellcheck disable=SC2164
		cd ~
		echo "Listen 80">$FILE
		echo "<VirtualHost *:80>">$FILE
		# shellcheck disable=SC2129
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
	sleep 3

	Text_TITLE "• •"

	Text_TITLE "• Выполнение команд: •"
	Text_n "•  >> a2enmod rewrite •"
	  a2enmod rewrite
	Text_n "•  >> a2enmod php*.* •"
	  a2enmod php*.*
	Text_n "•  >> service apache2 restart •"
	  service apache2 restart
	Text_n "•  >> cd ~ •"
    # shellcheck disable=SC2164
    cd ~
	Text_TITLE "• Выполнение команд завершено •"

	Text_TITLE "• •"

  Text_TITLE "• • Создаю и подключаю каталог где будет хранится сайт: ${red}$INSTALL_DIR${green} • •"
	  mkdir $INSTALL_DIR/
	  # shellcheck disable=SC2164
	  cd $INSTALL_DIR/
	  rm -Rfv *
	Text_TITLE "• Каталог создан •"

	Text_TITLE "• •"

  Text_TITLE "• • Теперь создаю тестовый файл index.php • •"
    echo "<?php phpText_INFO(); ?>" > index.php
  Text_n "•  Тестовый файл создан •"

  Text_TITLE "• •"

	Text_n "•  Возвращаемся в домашний каталог •"
	  # shellcheck disable=SC2164
	  cd ~
	Text_n "• Продолжаем... •"

	Text_TITLE "• •"

  Text_TITLE "${green}• • Пытаюсь задать часовой пояс МСК • •"
	  Text_n "${green}•  >> ${yellow}Europe/Moscow ${green}в ${yellow}/etc/timezone ${green}•"
	    echo "Europe/Moscow" > /etc/timezone
	      dpkg-reconfigure tzdata -f noninteractive
	    Text_n "${green}•  >> Теперь в ${yellow}/etc/php/*.*/cli/php.ini ${green}•"
        sudo sed -i -r 's~^;date\.timezone =$~date.timezone = "Europe/Moscow"~' /etc/php/*.*/cli/php.ini
	    Text_n "${green}•  >> Теперь в ${yellow}/etc/php/*.*/apache2/php.ini ${green}•"
        sudo sed -i -r 's~^;date\.timezone =$~date.timezone = "Europe/Moscow"~' /etc/php/*.*/apache2/php.ini
	  Text_TITLE "${red}"
	Text_TITLE "${red}• ГОТОВО! •"
	Text_TITLE "${red}"
	sleep 5

	Text_TITLE "• •"

	Text_TITLE "• Обновляю пакеты репозиториев •"
	sudo apt-get update -y
	Text_TITLE "• Завершаю обновление репозиториев •"

	Text_TITLE "• •"

	Text_TITLE "• Перезапускаю на последок модули Apache и MySQL •"
	service apache2 restart
	service mysql restart
	Text_TITLE "• Команды перезапуска выполнены •"

	clear
	Text_SEPARATOR
		Text_TITLE "${green}• • t.me/${red}MiKillCrafter ${green}• •"
	    Text_SEPARATOR
		Text_n "${red}Сайт установлен по этому пути:"
    Text_n "${blue}$INSTALL_DIR"
      Text_n ""
		Text_n "${yellow}http://$DOMAIN/${red}phpmyadmin"
      Text_n ""
		Text_n "${red}Логин${green}: ${yellow}root"
		Text_n "${red}Пароль${green}: ${yellow}$MYPASS"
		Text_n ""
		Text_SEPARATOR
	Text_INFO
	Text_TITLE "• Всё готово •"
	Text_INFO "0 – Выход ✔"
	Text_INFO
	# shellcheck disable=SC2162
	# shellcheck disable=SC2039
	read -p "Введи 0 чтобы завершить: " case
	case $case in
		0) exit;;
	esac
}

wait()
{
	clear
	if [ "$USER" = "root" ]; then
		Text_SEPARATOR
		Text_INFO
		Text_INFO "• ${blue}Ты точно хочешь запустить настройку сервера?"
		Text_INFO "• ${blue}Are you sure you want to start setting up the server?"
		Text_INFO
		  Text_INFO "${green}• - 1 - ДА – YES ✔ •"
		  Text_INFO "${red}• - 0 - НЕT – NO ✔ •"
		Text_INFO
		Text_SEPARATOR
		Text_INFO "${blue}Want to continue? (Input: ${green}1 or ${red}0${blue}): "
		# shellcheck disable=SC2162
		# shellcheck disable=SC2039
		read -p "${blue}Хотите продолжить? (Введи: ${green}1 или ${red}0${blue}): " case
		case $case in
			1) start_script;;
			0) exit;;
		esac
		clear
	else clear
		Text_INFO "${red}You are not a root | Вы не root"
	fi
}

wait