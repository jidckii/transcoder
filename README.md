# Transcoder instalation

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
sudo chmod 2775 /opt/transcoder/tmp
sudo chown transcoder:transcoder /opt/transcoder/tmp
sudo chmod 2775 /opt/transcoder/log
sudo chown transcoder:transcoder /opt/transcoder/log
```

создать симлинку для PATH

```
ls -s /opt/transcoder/bin/transcoder /usr/local/sbin/transcoder
```

# Для работы в режиме демона при этом с возможностью обрятной связи для инджестера запускать с параметрами:
 
 ```
/usr/local/sbin/transcoder >> /opt/transcoder/log/daemon.log 2>&1
```


