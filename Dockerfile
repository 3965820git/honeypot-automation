FROM ubuntu:22.04
# Добавляем 'git' для клонирования репозитория
RUN apt update && apt install -y openssh-server python3-pip git -y

RUN useradd -m honeypot
WORKDIR /home/honeypot

# Клонируем репозиторий Cowrie
RUN git clone https://github.com/cowrie/cowrie.git .

# Переходим в директорию клонированного репозитория Cowrie
WORKDIR cowrie

# Устанавливаем все зависимости Cowrie из файла requirements.txt
# '--no-cache-dir' помогает уменьшить размер итогового образа Docker
RUN pip install --no-cache-dir -r requirements.txt

# Копируем дистрибутивный файл конфигурации (если он нужен на этом этапе)
RUN cp etc/cowrie.cfg.dist etc/cowrie.cfg

# Команда для запуска Cowrie при старте контейнера
CMD ["bin/cowrie", "start", "-n"]
