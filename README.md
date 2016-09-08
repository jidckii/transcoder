# Transcoder instalation guide

Инструкция по  установке серверной части ingest transcoder на ubuntu

```
cd /opt
git clone https://github.com/jidckii/transcoder.git
```

Создаем пользователя с нужным именем и записываем в переменную $user в /opt/bin/transcoder

к примеру:

```
sudo adduser transcoder
```

создать у $user в домашней директории нужные каталоги

```
mkdir /home/$user/queue-video-tmp/
mkdir/home/$user/source-video-tmp/
mkdir /home/$user/end-video-tmp/
mkdir /home/$user/frank/
mkdir /home/$user/dalet
```

назначить правильные права на рабочий каталог

```
sudo chmod -R 2775 /opt/transcoder/tmp
sudo chown -R transcoder:transcoder /opt/transcoder/tmp
sudo chmod -R 2775 /opt/transcoder/log
sudo chown -R transcoder:transcoder /opt/transcoder/log
```

создать симлинку для PATH

```
sudo ln -s /opt/transcoder/bin/transcoder /usr/local/sbin/transcoder
```
Дать права на исполнение
```
sudo chmod +x /opt/transcoder/bin/transcoder
```

# Для работы в режиме демона при этом с возможностью обрятной связи для инджестера запускать с параметрами:
 
 ```
/usr/local/sbin/transcoder >> /opt/transcoder/log/daemon.log 2>&1
```
читать вывод 
```
tail -f /opt/transcoder/log/daemon.log
```
