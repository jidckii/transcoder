#!/bin/bash

set -x

pre_list_file=/opt/aid-transcoder/tmp/pre_list_file.txt
list_file=/opt/aid-transcoder/tmp/list_file.txt
template=/opt/aid-transcoder/tmp/template.sh
workcopy=/opt/aid-transcoder/tmp/workcopy.sh
bad_list1=/opt/aid-transcoder/tmp/bad_list1.txt
bad_list2=/opt/aid-transcoder/tmp/bad_list2.txt
s_str=/opt/aid-transcoder/tmp/s_diff.txt
d_str=/opt/aid-transcoder/tmp/d_diff.txt
log=/opt/aid-transcoder/log/aid.log
LOG=/opt/aid-transcoder/log/aid.log
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
text6="Обсчет завершен, копирую в Dalet и на FRANK"
text7="Обнаружен материал объемом"
text8="mediainfo материала исходного:"
text9="mediainfo материала конечного:"
text10="При обсчете следующих файлов возникли проблемы:"
text11="Данные файлы будут скопированный на Frank в папку bad_file за сегодняшнее число!"
text12="Идет объединение"
time_enter="Начата обработка"
time_end="Завершена обработка"
no_profile="Профиль для входящего видео не задан!"

SD_V_CODEC="dvvideo"
SD_A_CODEC="pcm_s16le"
FHD_V_CODEC="libx264"
FHD_A_CODEC="ac3"

TRANS_CONT="mp4"

log_info(){
  DATE=$(date +%H:%M:%S_%d-%m-%Y)
  echo -e '\n' "$DATE ----> $*" '\n' >> $LOG 2>&1
}

log_info_file(){
  DATE=$(date +%H:%M:%S_%d-%m-%Y)
  echo -e '\n' "$DATE ----> $*" '\n' >> $LOG_FILE 2>&1
}

log_copy(){
  mkdir $frank_path$date_dir$end_log_dir > /dev/null 2>&1
  zip -r $log_dir$end_file_name.zip $list_file $log_dir$end_file_name > /dev/null 2>&1
  cp $log_dir$end_file_name.zip  $frank_path$date_dir$end_log_dir
}

rm_all_file(){
  rm -r -f $source_path* && rm -r -f $end_path* && rm -r -f $trans_source_path* && rm -r -f $log_dir* > /dev/null 2>&1
  rm  $pre_list_file $list_file > /dev/null 2>&1
}

FF_SD(){
  if [[ "$media_info_stp" -eq "1" ]]; then
  tmp_video_size_hum=$(du -s -h $source_path | awk '{print $1}')
  log_info "\e[1;32m $text3 \e[1;93m $end_file_name \e[1;95m $s_wc \e[1;32m файлов \e[1;32m объемом \e[1;95m $tmp_video_size_hum \e[0m"
  log_info_file $time_enter
  log_info_file $end_file_name
  mkdir $trans_source_path$end_file_name 2>&1
  for name in $(ls -1 $source_path$end_file_name); do
    sleep 0.5
    # Запускаем обсчет
    ffmpeg \
      -i $source_path$end_file_name/$name -c:v $SD_V_CODEC -s 720x576 -vf crop=in_w-2*222 \
      -c:a $SD_A_CODEC -f $TRANS_CONT $trans_source_path$end_file_name/$name.$TRANS_CONT > $log_dir$end_file_name/$name.log 2>&1 &
  done
elif [[ "$media_info_stp" -eq "4" ]]; then
  tmp_video_size_hum=$(du -s -h $source_path | awk '{print $1}')
  log_info "\e[1;32m $text3 \e[1;93m $end_file_name \e[1;95m $s_wc \e[1;32m файлов \e[1;32m объемом \e[1;95m $tmp_video_size_hum \e[0m"
  log_info_file $time_enter 
  log_info_file $end_file_name
  mkdir $trans_source_path$end_file_name 2>&1
  for name in $(ls -1 $source_path$end_file_name); do
    sleep 0.5
    # Запускаем обсчет
    ffmpeg \
      -i $source_path$end_file_name/$name -map 0:0 -c:v $SD_V_CODEC -s 720x576 -vf crop=in_w-2*222 \
      -filter_complex "[0:1][0:2][0:3][0:4] amerge=inputs=4,pan=stereo|c0=c0|c1<c1+c2+c3[aout]" -map "[aout]" \
      -ac 2 -c:a $SD_A_CODEC -f $TRANS_CONT $trans_source_path$end_file_name/$name.$TRANS_CONT > $log_dir$end_file_name/$name.log 2>&1 &
  done
else
  log_info "\e[1;31m $no_profile \e[0m "
  log_copy
  return 1
fi
}

FF_FHD(){
  if [[ "$media_info_stp" -eq "1" ]]; then
  tmp_video_size_hum=$(du -s -h $source_path | awk '{print $1}')
  log_info "\e[1;32m $text3 \e[1;93m $end_file_name \e[1;95m $s_wc \e[1;32m файлов \e[1;32m объемом \e[1;95m $tmp_video_size_hum \e[0m"
  log_info_file $time_enter
  log_info_file $end_file_name
  mkdir $trans_source_path$end_file_name 2>&1
  for name in $(ls -1 $source_path$end_file_name); do
    sleep 0.5
    # Запускаем обсчет
    ffmpeg \
      -i $source_path$end_file_name/$name -c:v $FHD_V_CODEC -b:v 10000K\
      -c:a $FHD_A_CODEC -f $TRANS_CONT $trans_source_path$end_file_name/$name.$TRANS_CONT > $log_dir$end_file_name/$name.log 2>&1 &
  done
elif [[ "$media_info_stp" -eq "4" ]]; then
  tmp_video_size_hum=$(du -s -h $source_path | awk '{print $1}')
  log_info "\e[1;32m $text3 \e[1;93m $end_file_name \e[1;95m $s_wc \e[1;32m файлов \e[1;32m объемом \e[1;95m $tmp_video_size_hum \e[0m"
  log_info_file $time_enter
  log_info_file $end_file_name
  mkdir $trans_source_path$end_file_name 2>&1
  for name in $(ls -1 $source_path$end_file_name); do
    sleep 0.5
    # Запускаем обсчет
    ffmpeg \
      -i $source_path$end_file_name/$name -map 0:0 -c:v $FHD_V_CODEC -preset veryfast -b:v 10000K\
      -filter_complex "[0:1][0:2][0:3][0:4] amerge=inputs=4,pan=stereo|c0=c0|c1<c1+c2+c3[aout]" -map "[aout]" \
      -ac 2 -c:a $FHD_A_CODEC -f $TRANS_CONT $trans_source_path$end_file_name/$name.$TRANS_CONT > $log_dir$end_file_name/$name.log 2>&1 &
  done
else
  log_info "\e[1;31m $no_profile \e[0m "
  log_copy
  return 1
fi
}



transcoding(){

DATE=$(date +%H:%M:%S_%d-%m-%Y)
date_dir=$(date +%d.%m.%Y)
next_file=`ls -t -r -1 $queue_path | awk '{print $1}' | head -n 1`

mv $queue_path$next_file $source_path       # перемещаем из очереди в рабочий каталог
end_file_name=$(ls -1 $source_path)
END_FORMAT=$(echo $end_file_name | awk -F. '{print $NF}')
media_info_name=$(ls -1 $source_path$end_file_name | sed -n -e 1p)
media_info_stp=$(mediainfo $source_path$end_file_name/$media_info_name | grep Audio | wc -l)
s_wc=$(ls -1 $source_path$end_file_name | wc -l)
mkdir $log_dir$end_file_name
LOG_FILE=/home/transcoder/logs/$end_file_name/mediainfo.log

if [[ $END_FORMAT == "SD_4:3" ]]; then
  FORMAT_PATH=""
  CONTAINER="mov"
  FF_SD
elif [[ $END_FORMAT == "FHD_16:9" ]]; then
  FORMAT_PATH="FHD/"
  CONTAINER="mp4"
  FF_FHD
else
  log_info "\e[1;31m Ошибка определения формата SD/FHD \e[0m "
  log_info "$END_FORMAT"
  return 1
fi

sleep 1

ps_status=$(ps -e | grep ffmpeg | wc -l)
while [ "$ps_status" -gt "0" ]; do
  sleep 5
  ps_status=$(ps -e | grep ffmpeg | wc -l)
done
d_wc=$(ls -1 $trans_source_path$end_file_name | wc -l)
if [ "$s_wc" -ne "$d_wc" ]; then
  ls -1 $source_path$end_file_name > $s_str
  ls -1 $trans_source_path$end_file_name  | sed 's/.$TRANS_CONT//g' > $d_str
  diff $s_str $d_str | awk 'FNR>1' | awk '{print $2}' > $bad_list1
  bad_list=$(cat $bad_list1)
  log_info "\e[1;31m $text10 \e[0m "
  log_info $bad_list
  log_info "\e[1;31m $text11 \e[0m"
  log_info $text10 '\n' $bad_list '\n'
  awk '{print "cp '$source_path$end_file_name'/"$0" '$frank_path$date_dir$bad_dir$end_file_name'"}' $bad_list1 > $bad_list2
  cp $template $workcopy
  echo `cat $bad_list2` >> $workcopy
  mkdir -p $frank_path$date_dir$bad_dir$end_file_name > /dev/null 2>&1
  sh $workcopy
fi

find $trans_source_path -name "*.$TRANS_CONT" > $pre_list_file 2>&1
awk '{print "file "$0""}' $pre_list_file | sort > $list_file 2>&1
tmp_video_size_hum=$(du -s -h $trans_source_path | awk '{print $1}')
log_info "\e[1;32m $text12 \e[1;33m $end_file_name \e[1;95m $d_wc \e[1;32m файлов \e[0m"
log_info_file $text8 
mediainfo $source_path$end_file_name/$media_info_name >> $LOG_FILE 2>&1
sleep 1
# Запускаем объединение
ffmpeg \
-f concat -safe 0 -i $list_file -map 0 -c copy -f $CONTAINER \
$end_path$end_file_name.$CONTAINER > $log_dir$end_file_name/$end_file_name.log 2>&1 & pid_ffmpeg=$!
wait $pid_ffmpeg

if [[ "$?" -ne 0 ]]; then
  log_info "\e[1;31m Ошибка при объединении \e[0m "
  log_copy
  
  return 1
fi
}

_copy(){
log_info_file $text9 
mediainfo $end_path$end_file_name.$CONTAINER  >> $LOG_FILE 2>&1
DATE_end=`date +%H:%M_%d-%m-%Y`
log_info_file $time_end
log_info_file "Finish time"
log_copy
log_info "\e[4;33m $text6 \e[0m"

if [[ -d "$dalet_path" ]];then
  cp $end_path$end_file_name.$CONTAINER $dalet_path/$FORMAT_PATH >> $LOG_FILE 2>&1 & pid_cp=$!
else
  log_info "\e[1;31m Ошибка при копировании в dalet, путь не найден \e[0m"
fi

if [[ -d "$frank_path$date_dir" ]];then
  cp -R $source_path* $frank_path$date_dir$v_hd >> $LOG_FILE  2>&1 & pid_cp1=$!
else
  log_info "\e[1;31m Ошибка при копировании на FRANK, путь не найден \e[0m"
fi

if [[ -d "$frank_path$date_dir" ]];then
  cp $end_path$end_file_name.$CONTAINER $frank_path$date_dir$dlya_montaja >> $LOG_FILE 2>&1 & pid_cp2=$!
else
  log_info "\e[1;31m Ошибка при копировании на FRANK, путь не найден \e[0m"
fi


wait $pid_cp
if [[ "$?" -ne 0 ]]; then
  log_info "\e[1;31m Ошибка при копировании в dalet  \e[0m"
  return 1
fi

wait $pid_cp1
if [[ "$?" -ne 0 ]]; then
  log_info "\e[1;31m Ошибка при копировании исходников на FRANK \e[0m "
  return 1
fi

wait $pid_cp2
if [[ "$?" -ne 0 ]]; then
  log_info "\e[1;31m Ошибка при копировании готового на FRANK \e[0m "
  return 1
fi

log_info "\e[1;35m $text5 \e[0m"
log_info "\e[1;96m $text1 \e[0m"
rm_all_file
return 0
}


while true; do
  tmp_video_size1=$(du -s $queue_path | awk '{print $1}')
  sleep 10

  while [[ "$tmp_video_size1" -gt "1000" ]]; do   # Проверям размер раталога
    tmp_video_size1=$(du -s $queue_path | awk '{print $1}')
    sleep 10
    tmp_video_size2=$(du -s $queue_path | awk '{print $1}')
    tmp_video_size_hum=$(du -s -h $queue_path | awk '{print $1}')
    log_info "\e[0;32m $text7 \e[1;95m $tmp_video_size_hum  \e[0m"

    if [[ "$tmp_video_size1" -ne "$tmp_video_size2" ]]; then  # Убеждаемся, что временный каталог более не растет
      log_info "\e[0;32m $text2 \e[0m"
      continue
    fi

    transcoding
    if [[ "$?" -ne 0 ]]; then
      log_info "\e[1;31m Функция транскодирования завершилась ошибкой. Обратитесь к системному администратору \e[0m "
      rm_all_file
      break
    fi

    _copy
    if [[ "$?" -ne 0 ]]; then
      log_info "\e[1;31m Функция копирования завершилась ошибкой. Обратитесь к системному администратору \e[0m "
      rm_all_file
      break
    fi

    break
  done
done
