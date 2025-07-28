FROM ubuntu:22.04

# 1. Устанавливаем необходимые пакеты, включая 'git' для клонирования репозитория
RUN apt update && apt install -y openssh-server python3-pip git -y

# Создаем пользователя honeypot
RUN useradd -m honeypot

# Переходим в домашнюю директорию пользователя honeypot
WORKDIR /home/honeypot

# 2. Клонируем репозиторий Cowrie в новую поддиректорию 'cowrie' внутри /home/honeypot
RUN git clone https://github.com/cowrie/cowrie.git cowrie

# 3. Теперь меняем рабочую директорию на клонированный репозиторий Cowrie
WORKDIR cowrie

# 4. Устанавливаем все Python-зависимости Cowrie из файла requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Копируем дистрибутивный файл конфигурации
RUN cp etc/cowrie.cfg.dist etc/cowrie.cfg

# --- НОВЫЕ СТРОКИ ДЛЯ ИСПРАВЛЕНИЯ ПУТЕЙ ЛОГОВ В КОНФИГУРАЦИИ COWRIE ---
# Изменяем пути к файлам логов в cowrie.cfg на абсолютные
RUN sed -i 's|^logfile = var/log/cowrie/cowrie.json|logfile = /var/log/cowrie/cowrie.json|g' etc/cowrie.cfg
RUN sed -i 's|^logfile = var/log/cowrie/cowrie.log|logfile = /var/log/cowrie/cowrie.log|g' etc/cowrie.cfg
# Дополнительно, на случай других переменных
RUN sed -i 's|^jsonlog = var/log/cowrie/cowrie.json|jsonlog = /var/log/cowrie/cowrie.json|g' etc/cowrie.cfg
RUN sed -i 's|^textlog = var/log/cowrie/cowrie.log|textlog = /var/log/cowrie/cowrie.log|g' etc/cowrie.cfg
# --- КОНЕЦ НОВЫХ СТРОК ---

# Создаем абсолютную директорию для логов и устанавливаем владельца honeypot
# Этот путь теперь согласуется с тем, что Cowrie будет искать
RUN mkdir -p /var/log/cowrie && chown honeypot:honeypot /var/log/cowrie

# Определение пользователя, под которым будет работать контейнер по умолчанию
USER honeypot

# Открытие портов для Cowrie (например, SSH)
EXPOSE 2222

# Команда, которая будет выполняться при запуске контейнера
CMD ["bin/cowrie", "start", "-n"]
