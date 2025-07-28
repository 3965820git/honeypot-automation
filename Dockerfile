FROM ubuntu:22.04

# 1. Устанавливаем необходимые пакеты, включая 'git' для клонирования репозитория
RUN apt update && apt install -y openssh-server python3-pip git -y

# Создаем пользователя honeypot
RUN useradd -m honeypot

# Переходим в домашнюю директорию пользователя honeypot
WORKDIR /home/honeypot

# 2. Клонируем репозиторий Cowrie в *новую* поддиректорию 'cowrie' внутри /home/honeypot
#    Это решит проблему "destination path '.' already exists"
RUN git clone https://github.com/cowrie/cowrie.git cowrie

# 3. Теперь меняем рабочую директорию на клонированный репозиторий Cowrie
WORKDIR cowrie

# 4. Устанавливаем все Python-зависимости Cowrie из файла requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Копируем дистрибутивный файл конфигурации (если он нужен на этом этапе)
RUN cp etc/cowrie.cfg.dist etc/cowrie.cfg

# Определение пользователя, под которым будет работать контейнер по умолчанию
USER honeypot

# Открытие портов для Cowrie (например, SSH)
EXPOSE 2222

# Команда, которая будет выполняться при запуске контейнера
CMD ["bin/cowrie", "start", "-n"]
