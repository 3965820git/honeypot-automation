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

# Изменяем log_path в cowrie.cfg на абсолютный путь
RUN sed -i 's|^log_path = var/log/cowrie|log_path = /var/log/cowrie|g' etc/cowrie.cfg

# --- НОВАЯ ДОБАВЛЕННАЯ СТРОКА ---
# Создаем директорию для PID-файла внутри установочного пути Cowrie и устанавливаем права
RUN mkdir -p /home/honeypot/cowrie/var/run && chown honeypot:honeypot /home/honeypot/cowrie/var/run
# --- КОНЕЦ НОВОЙ СТРОКИ ---

# Создаем абсолютную директорию для логов и устанавливаем владельца honeypot
RUN mkdir -p /var/log/cowrie && chown honeypot:honeypot /var/log/cowrie

# Определение пользователя, под которым будет работать контейнер по умолчанию
USER honeypot

# Открытие портов для Cowrie (например, SSH)
EXPOSE 2222

# Команда, которая будет выполняться при запуске контейнера
CMD ["bin/cowrie", "start", "-n"]
