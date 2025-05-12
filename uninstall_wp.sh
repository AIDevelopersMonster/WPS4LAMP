#!/bin/bash

# === Проверка на root ===
if [[ $EUID -ne 0 ]]; then
    echo "🚫 Этот скрипт нужно запускать с правами root. Используй: sudo ./uninstall_wp.sh"
    exit 1
fi

# === Ввод имени сайта ===
read -p "Введите доменное имя сайта (например, vhdl.local): " SITE_NAME
DB_NAME="wp_${SITE_NAME//./_}"
DB_USER="admin_${SITE_NAME//./_}"
WP_DIR="/var/www/${SITE_NAME}"
APACHE_CONF="/etc/apache2/sites-available/${SITE_NAME}.conf"

echo "⛔ Удаляем сайт: ${SITE_NAME}"
echo "📂 Путь: ${WP_DIR}"
echo "🗃 БД: ${DB_NAME}"
echo "👤 Пользователь MySQL: ${DB_USER}"

# === Подтверждение ===
read -p "Вы уверены, что хотите удалить этот сайт и все связанные данные? (y/N): " CONFIRM
if [[ $CONFIRM != "y" ]]; then
    echo "❎ Отмена удаления."
    exit 0
fi

# === Отключение виртуального хоста ===
a2dissite "${SITE_NAME}.conf" 2>/dev/null

# === Удаление Apache-конфигов ===
rm -f "/etc/apache2/sites-available/${SITE_NAME}.conf"
rm -f "/etc/apache2/sites-enabled/${SITE_NAME}.conf"

# === Удаление каталога сайта ===
rm -rf "${WP_DIR}"

# === Удаление базы данных и пользователя ===
mysql -e "DROP DATABASE IF EXISTS ${DB_NAME};"
mysql -e "DROP USER IF EXISTS '${DB_USER}'@'localhost';"

# === Удаление записи из /etc/hosts ===
sed -i "/${SITE_NAME}/d" /etc/hosts

# === Удаление из логов, если есть ===
sed -i "/${SITE_NAME}/d" ~/wp_sites.log 2>/dev/null

# === Перезапуск Apache ===
systemctl reload apache2

echo "✅ Сайт ${SITE_NAME} полностью удалён."