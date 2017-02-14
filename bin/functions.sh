# Support functions

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