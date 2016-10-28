# Transcoder instalation guide

Инструкция по установке серверной части ingest transcoder на ubuntu 16.04

При инсталяции OS, обязательно установить ssh-server, рекомендую оставить автообновление критических уязвимостей.


Прежде всего понадобится установить из стороннего репозиротся ffmpeg(программа FFmpeg с некоторых пор отсутствует в репозиториях Ubuntu. 
Вместо неё в репозиториях находится программа Libav, подробнее тут: http://help.ubuntu.ru/wiki/ffmpeg),
а так же все что понабится по пути из официального.

репа для ubuntu lts(14,16) со свежими сборками ffmpeg
```
sudo add-apt-repository ppa:djcj/hybrid
sudo apt-get update
sudo apt-get install ffmpeg
```
либо можно собрать свежую сборку самостоятельно скачав исходники с офф сайта ffmpeg: http://ffmpeg.org/

Оставшиеся зависимости для работы transcoder:

```
sudo apt-get install cifs-utils mediainfo zip 
```
Остальное для души:

```
sudo apt-get install vim htop 
```

Коприуем пргу к себе:
```
cd /opt
git clone https://github.com/jidckii/transcoder.git
```

Создаем пользователя с нужным именем к примеру:

```
sudo adduser transcoder
```

создать у transcoder в домашней директории нужные каталоги

```
mkdir /home/transcoder/queue-video-tmp/
mkdir /home/transcoder/source-video-tmp/
mkdir /home/transcoder/trans-video-tmp/
mkdir /home/transcoder/end-video-tmp/
mkdir /home/transcoder/frank/
mkdir /home/transcoder/dalet/
mkdir /home/transcoder/logs/
```

назначить правильные права на рабочий каталог

```
sudo chmod -R 2775 /opt/transcoder/tmp
sudo chown -R transcoder:transcoder /opt/transcoder/tmp
sudo chmod -R 2775 /opt/transcoder/log
sudo chown -R transcoder:transcoder /opt/transcoder/log
```


Дать права на исполнение
```
sudo chmod +x /opt/transcoder/bin/transcoder.sh
```

читать вывод 
```
tail -f /opt/transcoder/log/daemon.log
```

В /etc/fstab прописываем шары cifs в которые будем удаленно копировать
```
# Share
//netapp1.otv.loc/daletplus/Storage/RSU/IMPORT_EDITOR   /home/transcoder/dalet   cifs    _netdev,credentials=/root/.smbcredentials,rw,noperm,uid=transcoder,gid=transcoder,dir_mode=0777,file_mode=0777      0       0
//frank.otv.loc/frank/OBMEN_NEWS   /home/transcoder/frank   cifs    _netdev,credentials=/root/.smbcredentials,rw,noperm,uid=transcoder,gid=transcoder,dir_mode=0777,file_mode=0777      0       0

```
в файле credentials=/root/.smbcredentials
собственно данные авторизации такого формата
```
username=shareuser
password=sharepassword
domain=domain_or_workgroupname
```

так же что бы они точно понтировались после ребута добавляем в ctontab рута следующее:

sudo crontab -e
```
@reboot (sleep 30; /bin/mount -a)&
```

АВТОЗАПУСК:

для systemd юнит для автозапуска лежит в transcoder/etc/, его надо переместить в
/etc/systemd/system/
и выполнить 
````
sudo systemctl daemon-reload
sudo systemctl enable transcoder.service
sudo systemctl start transcoder.service
```
проверяем:
```
sudo systemctl status transcoder.service
```
вывод будет примерно такой:
```
$ systemctl status transcoder.service
● transcoder.service - Auto Ingest Daemon (AID)
   Loaded: loaded (/etc/systemd/system/transcoder.service; enabled; vendor preset: enabled)
   Active: active (running) since Пт 2016-10-28 17:35:02 +05; 35min ago
     Docs: https://github.com/jidckii/transcoder
  Process: 1457 ExecStartPre=/opt/transcoder/bin/rm.sh (code=exited, status=0/SUCCESS)
 Main PID: 1487 (bash)
    Tasks: 460
   Memory: 1.1G
      CPU: 1min 23.750s
   CGroup: /system.slice/transcoder.service
           ├─1487 /bin/bash -c /opt/transcoder/bin/transcoder.sh > /opt/transcoder/log/daemon.log
           └─1489 /bin/bash /opt/transcoder/bin/transcoder.sh


окт 28 17:35:02 ingest-transcoder systemd[1]: Starting Auto Ingest Daemon (AID)...
окт 28 17:35:02 ingest-transcoder systemd[1]: Started Auto Ingest Daemon (AID).
```

Для sys-v-init скрипт для init.d не писал, так как все делал уже на ubuntu 16.04 с systemd.
если OS на sys-v-init , то скрипт автозапуска нужно будет написать самостоятельно.

Готово, можно закидываться в /home/transcoder/queue-video-tmp/ папку с исходниками и процесс пойдет.
Для парсинга и перемещения видео с USB SD используется отдельная рабочая станция.
подробнее тут : https://github.com/jidckii/mover


ВНИМАНИЕ !!!

Запрещается запускать более одной копии демона обновременно !!!
Проверяйте выполнение в процессах прежде чем запускать руками для каких бы то нибыло целей!!!

Автопроверку и lock еще не запилил...