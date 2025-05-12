#!/bin/bash

# === Проверка прав ===
if [ "$EUID" -ne 0 ]; then
  echo "🚫 Запусти скрипт от имени root или через sudo"
  exit 1
fi

# === Ввод имени сайта ===
read -p "Введите доменное имя сайта (например, cashtrack.local): " SITE_NAME
SITE_DIR="/var/www/${SITE_NAME}"
DB_NAME="my_${SITE_NAME//./_}"
DB_USER="admin_${SITE_NAME//./_}"
DB_PASS=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 16)

# === Создание директории сайта ===
mkdir -p "$SITE_DIR"
echo "<h1>${SITE_NAME} работает!</h1>" > "$SITE_DIR/index.html"
chown -R www-data:www-data "$SITE_DIR"
chmod -R 755 "$SITE_DIR"

# === Создание базы данных и пользователя ===
mysql -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# === Создание Apache-конфига ===
VHOST_FILE="/etc/apache2/sites-available/${SITE_NAME}.conf"
cat <<EOF > "$VHOST_FILE"
<VirtualHost *:80>
    ServerName ${SITE_NAME}
    DocumentRoot ${SITE_DIR}

    <Directory ${SITE_DIR}>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/${SITE_NAME}_error.log
    CustomLog \${APACHE_LOG_DIR}/${SITE_NAME}_access.log combined
</VirtualHost>
EOF

# === Активация сайта ===
a2ensite "${SITE_NAME}.conf"
a2enmod rewrite
systemctl reload apache2

# === Добавление в /etc/hosts ===
if ! grep -q "$SITE_NAME" /etc/hosts; then
  echo "127.0.0.1 $SITE_NAME" >> /etc/hosts
  echo "📝 Добавлено в /etc/hosts: 127.0.0.1 $SITE_NAME"
fi

# === Вывод информации ===
echo "\n✅ Сайт ${SITE_NAME} создан"
echo "🌍 URL: http://${SITE_NAME}"
echo "🗃 БД: ${DB_NAME}"
echo "👤 Пользователь: ${DB_USER}"
echo "🔑 Пароль: ${DB_PASS}"
