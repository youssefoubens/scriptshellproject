# 📊 Application Monitoring Script (Linux)

Un script Bash pour surveiller l'utilisation des applications et analyser l'activité système.

---

## 🌟 Features / Fonctionnalités

### 🔍 Application Monitoring
- ✅ Tracks app usage time (start/end timestamps)
- 📝 Logs activity to `~/app_monitor.log`
- 🔄 Runs in background (daemon mode)

### 🗂 Automated File Organization
- 🗃 Sorts Downloads folder by extension (PDF, JPG, ZIP, etc.)

### 📊 Server Analytics
- 👥 Lists logged-in users
- 💾 Displays disk/memory usage
- ⚙️ Shows running processes

---

## 🛠 Usage / Utilisation

### 🚀 Installation
```bash
chmod +x monitor_script.sh
./monitor_script.sh [OPTIONS]

##⚙️ Options
Option	Description	Commande Exemple
-s	Show server stats	./monitor_script.sh -s
-o	Organize Downloads folder	./monitor_script.sh -o
-b	Start background monitoring	./monitor_script.sh -b
-r	Stop background monitoring	./monitor_script.sh -r
-l	View activity log	./monitor_script.sh -l
-h	Show help	./monitor_script.sh -h
