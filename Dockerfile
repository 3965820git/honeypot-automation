FROM ubuntu:22.04 [cite: 164]
RUN apt update && apt install -y openssh-server python3-pip 
RUN pip install cowrie 
RUN useradd -m honeypot 
WORKDIR /home/honeypot 
RUN git clone https://github.com/cowrie/cowrie.git 
WORKDIR cowrie 
RUN cp etc/cowrie.cfg.dist etc/cowrie.cfg 
CMD ["bin/cowrie", "start", "-n"]
