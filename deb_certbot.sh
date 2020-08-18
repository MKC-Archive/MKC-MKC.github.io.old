#!/bin/sh
# Certbot installer

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
	Text_INFO "${blue}[Инфо]${green}: Введите путь c каталогом сайта"
	Text_INFO
	Text_INFO "${green}• (Пример | Example): ${yellow}/var/www ${green}"
	Text_INFO
	read -p "${green}Введи путь до сайта:${yellow} " INSTALL_DIR
	clear
	Text_INFO "${green}Enter ${red}domain ${green}or ${red}IP:${green}"
	read -p "${green}Введи ${red}домен ${green}или ${red}IP:${green} " DOMAIN
	clear

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

	Text_TITLE "• Тестируем автоматическое обновление •"
	  #sudo certbot renew
	  sudo certbot renew --dry-run
	Text_TITLE "• Тест был завершён •"

	clear
	Text_SEPARATOR
		Text_TITLE "${green}• • t.me/${red}MiKillCrafter ${green}• •"
	  Text_TITLE "${green}• • ${blue}https://MKC-MKC.GitHub.IO"
	  Text_SEPARATOR
		Text_INFO "${green}• • LetsEncrypt and Certbot successful installed! • •"
		Text_SEPARATOR
	Text_INFO
	Text_TITLE "• All done •"
	Text_TITLE "• Всё готово •"
	Text_INFO
	Text_INFO "0 – [Выход] ✔"
	Text_INFO "0 – [Exit] ✔"
	Text_INFO
	# shellcheck disable=SC2162
	# shellcheck disable=SC2039
	read -p "Введи 0 чтобы завершить: " case
	case $case in
		0) exit;;
	esac
}

updateCertOnly()
{
  Text_SEPARATOR

  Text_INFO "${blue}[Инфо]${green}: Введите путь c каталогом сайта"
	Text_INFO "$DOMAIN || $INSTALL_DIR"
	Text_INFO "${green}• (Пример | Example): ${yellow}/var/www ${green}"
	Text_INFO
	read -p "${green}Введи путь до сайта:${yellow} " INSTALL_DIR
	clear
	Text_INFO "${green}Enter ${red}domain ${green}or ${red}IP:${green}"
	read -p "${green}Введи ${red}домен ${green}или ${red}IP:${green} " DOMAIN
	clear

	Text_TITLE "• Обновляю сертификат •"
	  sudo certbot certonly --apache -n -d $DOMAIN -d www.$DOMAIN
	  sudo certbot renew
	  #sudo certbot renew --dry-run
	Text_TITLE "• Обновление заверено •"

	Text_SEPARATOR
}

wait()
{
	clear
	if [ "$USER" = "root" ];then
		Text_SEPARATOR
		Text_INFO
		Text_INFO "• ${blue}Тестовый скрипт автоматической настройки Certbot и LetsEncrypt"
		Text_INFO "• ${blue}Test script for automatic configuration of Certbot and LetsEncrypt"
		Text_INFO
		  Text_INFO "${yellow}• - 2 - Обновить только сертификат – Update certonly"
		  Text_INFO "${green}• - 1 - Настроить – Setup"
		  Text_INFO "${red}• - 0 - Выход – Exit ✔ •"
		Text_SEPARATOR
		Text_INFO "${blue}Input:  "
		# shellcheck disable=SC2162
		# shellcheck disable=SC2039
		read -p "${blue}Введи:  " case
		case $case in
			2) updateCertOnly;;
			1) start_script;;
			0) exit;;
		esac
		clear
	else
	  clear
		Text_INFO "${red}You are not a root | Вы не root"
	fi
}

wait