#!/bin/bash

pre_list_file=/opt/transcoder/tmp/pre_list_file.txt
list_file=/opt/transcoder/tmp/list_file.txt
template=/opt/transcoder/tmp/template.sh
workcopy=/opt/transcoder/tmp/workcopy.sh
bad_list1=/opt/transcoder/tmp/bad_list1.txt
bad_list2=/opt/transcoder/tmp/bad_list2.txt
s_str=/opt/transcoder/tmp/s_diff.txt
d_str=/opt/transcoder/tmp/d_diff.txt

# Изначально пользователя с таким именем нужно создать

queue_path=/home/transcoder/queue-video-tmp/
source_path=/home/transcoder/source-video-tmp/
end_path=/home/transcoder/end-video-tmp/
trans_source_path=/home/transcoder/trans-video-tmp/
frank_path=/home/transcoder/frank/
dalet_path=/home/transcoder/dalet/
v_hd='/ISHODNIKI_(S_FLASHKART_v_HD__ISHODNIKI_SKACHENNIYE_i_STORONNIYE)_i_NACHITKA/'
dlya_montaja='/MATERIALIY_DLYA_MONTAJA_S_INGESTA/'
bad_dir='/bad_file/'
log_dir=/home/transcoder/logs/
end_log_dir='/logs/'

ErrInProgress="Процесс transcoder уже запущен, для просмотра вывода используйте команду transcoder-view"

text1="Проверка наличия видео материала в очереди ..."
text2="Ожидается пауза при копировании в папку с очередью"
text3="Идет обсчет"
text4="Копирую на frank"
text5="Копирование завершено, удаляю временные файлы"
text6="Обсчет завершен, копирую в Dalet"
text7="Обнаружен материал объемом"
text8="mediainfo материала исходного:"
text9="mediainfo материала конечного:"
text10="При обсчете следующих файлов возникли проблемы:"
text11="Данные файлы будут скопированный на Frank в папку bad_file за сегодняшнее число!"
text12="Идет объединение"
time_enter="Обработка начата в"
time_end="Обработка завершена в"
no_profile="Профиль для входящего видео не задан!"

# Проверяем не запущена ли копия уже
# d_run=`ps aux | grep /usr/local/sbin/transcoder | grep -v grep`
# echo $d_run
# if [ "$d_run" -gt "1" ]; then
  # echo -e '\n' "\e[1;31m $ErrInProgress  \e[0m" '\n'
  # exit 1
# fi
# Заходим в цикл и работаем как бы в режиме демона
while true; do
  tmp_video_size1=`du -s $queue_path | awk '{print $1}'`
  sleep 10
  # echo -e '\n' "\e[0;32m $text1 \e[0m" '\n'

  while [ "$tmp_video_size1" -gt "1000" ]; do   # Проверям размер раталога
    tmp_video_size1=`du -s $queue_path | awk '{print $1}'`
    sleep 10
    tmp_video_size2=`du -s $queue_path | awk '{print $1}'`
    tmp_video_size_hum=`du -s -h $queue_path | awk '{print $1}'`
    echo -e '\n' "\e[0;32m $text7 \e[1;95m $tmp_video_size_hum  \e[0m" '\n'

    if [ "$tmp_video_size1" -ne "$tmp_video_size2" ]; then  # Убеждаемся, что временный каталог более не растет
      echo -e '\n' "\e[0;32m $text2 \e[0m" '\n'
      continue
    fi

    date_time=`date +%H:%M_%d-%m-%Y`
    date_dir=`date +%d.%m.%Y`
    next_file=`ls -t -r -1 $queue_path | awk '{print $1}' | head -n 1`
    mv $queue_path$next_file $source_path       # перемещаем из очереди в рабочий каталог
    end_file_name=`ls -1 $source_path`
    media_info_name=`ls -1 $source_path$end_file_name | sed -n -e 1p`
    media_info_stp=`mediainfo $source_path$end_file_name/$media_info_name | grep Audio | wc -l`
    s_wc=`ls -1 $source_path$end_file_name | wc -l`
    mkdir $log_dir$end_file_name
    log_file=/home/transcoder/logs/$end_file_name/mediainfo.log

    if [ "$media_info_stp" -eq "1" ]; then
      tmp_video_size_hum=`du -s -h $source_path | awk '{print $1}'`
      echo -e '\n' "$date_time" '\n'
      echo -e '\n' "\e[1;32m $text3 \e[1;93m $end_file_name \e[1;95m $s_wc \e[1;32m файлов \e[1;32m объемом \e[1;95m $tmp_video_size_hum \e[0m" '\n'
      echo -e $time_enter > $log_file 2>&1
      echo $date_time >> $log_file 2>&1
      echo $end_file_name >> $log_file 2>&1
      mkdir $trans_source_path$end_file_name 2>&1

      for name in $(ls -1 $source_path$end_file_name); do
        sleep 0.5
        # Запускаем обсчет
        ffmpeg \
          -i $source_path$end_file_name/$name -c:v dvvideo -s 720x576 -vf crop=in_w-2*222 \
          -c:a pcm_s16le -f mxf $trans_source_path$end_file_name/$name.mxf > $log_dir$end_file_name/$name.log 2>&1 &
      done
    elif [ "$media_info_stp" -eq "4" ]; then
      tmp_video_size_hum=`du -s -h $source_path | awk '{print $1}'`
      echo -e '\n' "$date_time" '\n'
      echo -e '\n' "\e[1;32m $text3 \e[1;93m $end_file_name \e[1;95m $s_wc \e[1;32m файлов \e[1;32m объемом \e[1;95m $tmp_video_size_hum \e[0m" '\n'
      echo -e $time_enter > $log_file 2>&1
      echo $date_time >> $log_file 2>&1
      echo $end_file_name >> $log_file 2>&1
      mkdir $trans_source_path$end_file_name 2>&1

      for name in $(ls -1 $source_path$end_file_name); do
        sleep 0.5
        # Запускаем обсчет
        ffmpeg \
          -i $source_path$end_file_name/$name -map 0:0 -c:v dvvideo -s 720x576 -vf crop=in_w-2*222 \
          -filter_complex "[0:1][0:2][0:3][0:4] amerge=inputs=4,pan=stereo|c0=c0|c1<c1+c2+c3[aout]" -map "[aout]" \
          -ac 2 -c:a pcm_s16le -f mxf $trans_source_path$end_file_name/$name.mxf > $log_dir$end_file_name/$name.log 2>&1 &
      done
    else
      echo -e '\n' "\e[1;31m $no_profile \e[0m "'\n'
    fi

    sleep 1
    ps_status=`ps -e | grep ffmpeg | wc -l`
    while [ "$ps_status" -gt "0" ]; do
      sleep 5
      ps_status=`ps -e | grep ffmpeg | wc -l`
    done

    d_wc=`ls -1 $trans_source_path$end_file_name | wc -l`

    if [ "$s_wc" -ne "$d_wc" ]; then
      ls -1 $source_path$end_file_name > $s_str
      ls -1 $trans_source_path$end_file_name  | sed 's/.mxf//g' > $d_str
      diff $s_str $d_str | awk 'FNR>1' | awk '{print $2}' > $bad_list1
      bad_list=`cat $bad_list1`
      echo -e '\n' "\e[1;31m $text10 \e[0m "'\n'
      echo -e $bad_list
      echo -e '\n' "\e[1;31m $text11 \e[0m" '\n'
      echo -e $text10 '\n' $bad_list '\n' >> $log_file 2>&1
      awk '{print "cp '$source_path$end_file_name'/"$0" '$frank_path$date_dir$bad_dir$end_file_name'"}' $bad_list1 > $bad_list2
      cp $template $workcopy
      echo `cat $bad_list2` >> $workcopy
      mkdir -p $frank_path$date_dir$bad_dir$end_file_name > /dev/null 2>&1
      sh $workcopy
    fi

    find $trans_source_path -name "*.mxf" > $pre_list_file 2>&1
    awk '{print "file \x27"$0"\x27"}' $pre_list_file | sort > $list_file 2>&1
    tmp_video_size_hum=`du -s -h $trans_source_path | awk '{print $1}'`
    echo -e '\n' "\e[1;32m $text12 \e[1;33m $end_file_name \e[1;95m $d_wc \e[1;32m файлов \e[0m" '\n'
    echo -e '\n' $text8  '\n' >> $log_file
    mediainfo $source_path$end_file_name/$media_info_name >> $log_file 2>&1
    sleep 1
    # Запускаем объединение
    ffmpeg -f concat -safe 0 -i $list_file -map 0:0 -map 0:1 -c copy -f mov $end_path$end_file_name.mov > $log_dir$end_file_name/$end_file_name.log 2>&1 &

    sleep 1
    ps_status=`ps -e | grep ffmpeg | wc -l`
    while [ "$ps_status" -gt "0" ]; do
      sleep 2
      ps_status=`ps -e | grep ffmpeg | wc -l`
    done

    sleep 1
    echo -e '\n' $text9 '\n' >> $log_file 2>&1
    mediainfo $end_path$end_file_name.mov >> $log_file 2>&1
    date_time_end=`date +%H:%M_%d-%m-%Y`
    echo -e '\n' $time_end >> $log_file 2>&1
    echo -e $date_time_end >> $log_file 2>&1
    mkdir $frank_path$date_dir$end_log_dir > /dev/null 2>&1
    zip -r $log_dir$end_file_name.zip $log_dir$end_file_name > /dev/null 2>&1
    echo -e '\n' "\e[4;33m $text6 \e[0m" '\n'
    cp $end_path$end_file_name.mov $dalet_path >> $log_file 2>&1
    echo -e '\n' "\e[4;33m $text4 \e[0m" '\n'
    cp -R $source_path* $frank_path$date_dir$v_hd >> $log_file  2>&1
    cp $end_path$end_file_name.mov $frank_path$date_dir$dlya_montaja >> $log_file 2>&1
    cp $log_dir$end_file_name.zip $frank_path$date_dir$end_log_dir
    echo -e '\n' "\e[1;35m $text5 \e[0m" '\n'
    rm -r -f $source_path* && rm -r -f $end_path* && rm -r -f $trans_source_path* && rm -r -f $log_dir* > /dev/null 2>&1
    rm  $pre_list_file $list_file > /dev/null 2>&1
    echo -e '\n' "$date_time_end" '\n'
    echo -e '\n' "\e[1;96m $text1 \e[0m" '\n'
    break
  done
done
