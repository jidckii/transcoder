#!/bin/bash

# set -x

AID_HOME_PATH=${AID_HOME_PATH:-"/opt/aid-server"}

AID_BIN_PATH=${AID_BIN_PATH:-"$AID_HOME_PATH/bin"}
AID_LOG_PATH=${AID_LOG_PATH:-"$AID_HOME_PATH/log"}
AID_TMP_PATH=${AID_TMP_PATH:-"$AID_HOME_PATH/tmp"}

AID_WORK_PATH=${AID_WORK_PATH:-"/home/transcoder"}

# source "${$AID_BIN_PATH/ff_fhd.sh}"
# source "${$AID_BIN_PATH/ff_sd.sh}"
source "${AID_BIN_PATH}/functions.sh"
source "${AID_BIN_PATH}/variables.sh"
source "${AID_BIN_PATH}/copy.sh"
source "${AID_BIN_PATH}/transcoding.sh"
source "${AID_BIN_PATH}/format_check.sh"

variables "$@"

while true; do
  tmp_video_size1=$(du -s $queue_path | awk '{print $1}')
  sleep 10

  while [[ "$tmp_video_size1" -gt "1000" ]]; do   # Проверям размер раталога
    tmp_video_size1=$(du -s $queue_path | awk '{print $1}')
    sleep 10
    tmp_video_size2=$(du -s $queue_path | awk '{print $1}')
    tmp_video_size_hum=$(du -s -h $queue_path | awk '{print $1}')
    log_info "\e[0;32m $text7 \e[1;95m $tmp_video_size_hum  \e[0m"

    # Убеждаемся, что временный каталог более не растет
    if [[ "$tmp_video_size1" -ne "$tmp_video_size2" ]]; then  
      log_info "\e[0;32m $text2 \e[0m"
      continue
    fi

    COUNTER=$(cat $COUNTER_LOG)
    let COUNTER=COUNTER+1
    echo $COUNTER > $COUNTER_LOG

    transcoding
    if [[ "$?" -ne 0 ]]; then
      log_info "\e[1;31m Функция транскодирования завершилась ошибкой. \n \
      Обратитесь к системному администратору \e[0m "
      rm_all_file
      break
    fi

    _copy
    if [[ "$?" -ne 0 ]]; then
      log_info "\e[1;31m Функция копирования завершилась ошибкой. \n \
      Обратитесь к системному администратору \e[0m "
      rm_all_file
      break
    fi

    break
  done
done
