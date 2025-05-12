# WPS4LAMP
Вот оформленный `README.md` файл специально для **GitHub**, с поддержкой **двух языков (русский + английский)**, стилем, подходящим для разработчиков и одноплатниководов.

---

````markdown
# 🌐 WordPress on SBC: Rapid Deployment Guide

> 🇷🇺 Быстрая установка WordPress-сайта на локальном одноплатном ПК с LAMP  
> 🇬🇧 Quick WordPress deployment on a local SBC using LAMP stack

---

## 📦 Requirements / Требования

- 🖥️ Single-board computer (Raspberry Pi, Orange Pi, G30, etc.)
- 🐧 Debian or Ubuntu Server preinstalled
- 🔧 Apache + MySQL (MariaDB) + PHP (LAMP stack)
- 📝 Script `install_wp.sh` in `~/scripts`

---

## 🚀 Installation / Установка

### Terminal on the SBC:
```bash
cd ~/scripts
sudo ./install_wp.sh
````

You'll be prompted to enter a site domain, like `my_site.local`.

The script will:

* Create `/var/www/my_site.local`
* Configure Apache
* Create MySQL database `wp_my_site_local`
* Set passwords and install WordPress
* Add entry to `/etc/hosts`
* Output WordPress and DB credentials

---

## 🌐 Accessing Your Site / Как открыть сайт

### 🔸 On the server (сервер):

Nothing to do — `127.0.0.1 my_site.local` is auto-added.

### 🔹 On another PC in LAN (другой ПК в сети):

Find server IP:

```bash
hostname -I
```

Then edit your client’s `hosts` file:

* **Linux/macOS**:

  ```bash
  sudo nano /etc/hosts
  # Add:
  192.168.1.xx my_site.local
  ```

* **Windows**:
  Open Notepad as Administrator →
  Open file: `C:\Windows\System32\drivers\etc\hosts`
  Add:

  ```
  192.168.1.xx my_site.local
  ```

📌 You can also use PowerShell:

```powershell
Add-Content -Path "C:\Windows\System32\drivers\etc\hosts" -Value "`n192.168.1.xx my_site.local"
```

Now open in your browser:

```
http://my_site.local
```

---

## 🔐 Credentials Log / Где смотреть доступы

```bash
cat ~/wp_sites.log
```

Example:

```
http://my_site.local | WP: admin_my_site_local / zP2txA9kR0qN | MySQL: admin_my_site_local / sJf83lY9w8jLm
```

---

## 🛠️ Useful Commands / Полезные команды

```bash
sudo apache2ctl -S                 # Check Apache config
sudo systemctl restart apache2    # Restart Apache
sudo rm -rf /var/www/html/*       # Clear default page
sudo tee /var/www/html/index.html <<< "<h1>Здесь ничего нет</h1>"

# Remove site
sudo a2dissite my_site.local.conf
sudo rm -rf /var/www/my_site.local
sudo mysql -e "DROP DATABASE wp_my_site_local;"
```

---

## 💡 Tips / Рекомендации

* Use lowercase names: `myblog.local`, `site42.local`
* Avoid spaces, uppercase, or special characters
* Keep each WP site in its own folder and DB

---

## 📬 Questions?

💬 Comment under the related video or open an issue in this repo!
✉️ Или пиши прямо сюда, если хочешь ещё круче WordPress-сервер 😉

---

```

---


