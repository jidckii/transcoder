# Transcoding

transcoding(){
  date_dir=$(date +%d.%m.%Y)
  next_file=`ls -t -r -1 $queue_path | awk '{print $1}' | head -n 1`
  
  mv $queue_path$next_file $source_path       # перемещаем из очереди в рабочий каталог
  end_file_name=$(ls -1 $source_path)
  mkdir $log_dir$end_file_name
  LOG_FILE="$log_dir$end_file_name/mediainfo.log"

  format_check
  if [[ "$?" -ne 0 ]]; then
    log_info "\e[1;31m Функция format_check завершилась ошибкой. \n \
    Обратитесь к системному администратору \e[0m "
    log_copy
    return 1
  fi

  s_wc=$(ls -1 $source_path$end_file_name | wc -l)
  tmp_video_size_hum=$(du -s -h $source_path | awk '{print $1}')
  log_info "\e[1;32m $text3 \e[1;93m $end_file_name \e[1;95m \
  $s_wc \e[1;32m файлов \e[1;32m объемом \e[1;95m $tmp_video_size_hum \e[0m"
  log_info_file $time_enter
  log_info_file $end_file_name
  mkdir $trans_source_path$end_file_name 2>&1

  if [[ "$media_info_stp" -eq "1" ]]; then
    for name in $(ls -1 $source_path$end_file_name); do
    sleep 0.5
    # Запускаем обсчет
      ffmpeg \
      -i $source_path$end_file_name/$name $MAP_SET -c:v $V_CODEC $SETING_VIDEO \
      -c:a $A_CODEC $SETING_AUDIO \
      -f $TRANS_CONT $trans_source_path$end_file_name/$name.$TRANS_CONT > $log_dir$end_file_name/$name.log 2>&1 &
    done
  elif [[ "$media_info_stp" -eq "4" ]]; then
        for name in $(ls -1 $source_path$end_file_name); do
    sleep 0.5
    # Запускаем обсчет
      ffmpeg \
      -i $source_path$end_file_name/$name $MAP_SET -c:v $V_CODEC $SETING_VIDEO \
      -filter_complex "[0:1][0:2][0:3][0:4] amerge=inputs=4,pan=stereo|c0=c0|c1<c1+c2+c3[aout]" -map "[aout]" \
      -c:a $A_CODEC $SETING_AUDIO \
      -f $TRANS_CONT $trans_source_path$end_file_name/$name.$TRANS_CONT > $log_dir$end_file_name/$name.log 2>&1 &
    done
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
    awk '{print "cp '$source_path$end_file_name'/"$0" \
    '$frank_path$date_dir$bad_dir$end_file_name/'"}' $bad_list1 > $bad_list2
    cp $template $workcopy
    echo $(cat $bad_list2) >> $workcopy
    mkdir -p $frank_path$date_dir$bad_dir$end_file_name > /dev/null 2>&1
    sh $workcopy
    log_copy
    return 1
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
  $end_path$end_file_name.$CONTAINER > $log_dir$end_file_name/$end_file_name.log 
  
  if [[ "$?" -ne 0 ]]; then
    log_info "\e[1;31m Ошибка при объединении \e[0m "
    log_copy   
    return 1
  fi
}