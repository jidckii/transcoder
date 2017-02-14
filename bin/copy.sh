# copy

_copy(){
  log_info_file $text9 
  mediainfo $end_path$end_file_name.$CONTAINER  >> $LOG_FILE 2>&1
  log_info_file $time_end
  log_info_file "Finish time"
  log_copy
  log_info "\e[4;33m $text6 \e[0m"
  
  if [[ -d "$dalet_path" ]];then
    cp $end_path$end_file_name.$CONTAINER $dalet_path$FORMAT_PATH >> $LOG_FILE 2>&1 & pid_cp=$!
  else
    log_info "\e[1;31m Ошибка при копировании в DALET, путь не найден \e[0m"
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
    log_info "\e[1;31m Ошибка во время копирования готового в DALET \e[0m"
    return 1
  fi
  
  wait $pid_cp1
  if [[ "$?" -ne 0 ]]; then
    log_info "\e[1;31m Ошибка во время копирования исходников на FRANK \e[0m "
    return 1
  fi
  
  wait $pid_cp2
  if [[ "$?" -ne 0 ]]; then
    log_info "\e[1;31m Ошибка во время копирования готового на FRANK \e[0m "
    return 1
  fi
  
  log_info "\e[1;35m $text5 \e[0m"
  log_info "\e[1;96m $text1 \e[0m"
  rm_all_file
  return 0
}
