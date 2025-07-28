FROM ubuntu:22.04

# 1. Устанавливаем необходимые пакеты, включая 'git' для клонирования репозитория
RUN apt update && apt install -y openssh-server python3-pip git -y

# Создаем пользователя honeypot
RUN useradd -m honeypot

# Переходим в домашнюю директорию пользователя honeypot
WORKDIR /home/honeypot

# 2. Клонируем репозиторий Cowrie в текущую директорию (/home/honeypot)
RUN git clone https://github.com/cowrie/cowrie.git .

# 3. Переходим в директорию клонированного репозитория Cowrie
WORKDIR cowrie

# 4. Устанавливаем все Python-зависимости Cowrie из файла requirements.txt
#    ЭТА СТРОКА ЗАМЕНЯЕТ проблемную "RUN pip install cowrie"
RUN pip install --no-cache-dir -r requirements.txt

# Копируем дистрибутивный файл конфигурации (если он нужен на этом этапе)
RUN cp etc/cowrie.cfg.dist etc/cowrie.cfg

# Команда для запуска Cowrie при старте контейнера
CMD ["bin/cowrie", "start", "-n"]
