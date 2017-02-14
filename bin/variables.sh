# variables

variables(){

pre_list_file="$AID_TMP_PATH/pre_list_file.txt"
list_file="$AID_TMP_PATH/list_file.txt"
template="$AID_TMP_PATH/template.sh"
workcopy="$AID_TMP_PATH/workcopy.sh"
bad_list1="$AID_TMP_PATH/bad_list1.txt"
bad_list2="$AID_TMP_PATH/bad_list2.txt"
s_str="$AID_TMP_PATH/s_diff.txt"
d_str="$AID_TMP_PATH/d_diff.txt"
LOG="$AID_LOG_PATH/aid.log"
# Изначально пользователя с таким именем нужно создать

queue_path="$AID_WORK_PATH/queue-video-tmp/"
source_path="$AID_WORK_PATH/source-video-tmp/"
end_path="$AID_WORK_PATH/end-video-tmp/"
trans_source_path="$AID_WORK_PATH/trans-video-tmp/"
frank_path="$AID_WORK_PATH/frank/"
dalet_path="$AID_WORK_PATH/dalet/"
v_hd='/ISHODNIKI_(S_FLASHKART_v_HD__ISHODNIKI_SKACHENNIYE_i_STORONNIYE)_i_NACHITKA/'
dlya_montaja='/MATERIALIY_DLYA_MONTAJA_S_INGESTA/'
bad_dir='/bad_file/'
log_dir="$AID_WORK_PATH/logs/"
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
FIN_FORM_TXT="Конечный формат выбран:"

}

# SD_V_CODEC="dvvideo"
# SD_A_CODEC="pcm_s16le"
# FHD_V_CODEC="mpeg2video"
# FHD_A_CODEC="pcm_s16le"

# SETING_VIDEO="-b:v 35M -r 25 -top 1 -flags +ilme+ildct" # -profile:v main -level:v 3.0
# SETING_AUDIO="-b:a 256K"
