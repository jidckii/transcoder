# format checker

p_fhd_mts(){
	AUDIO_COMPLEX=""
	FORMAT_PATH="RSU_HD_MXF/"
	CONTAINER="mxf"
	TRANS_CONT="mxf"
	V_CODEC="mpeg2video"
	A_CODEC="pcm_s16le"
	SETING_VIDEO="-b:v 35M -r 25 -top 1 -flags +ilme+ildct"
	SETING_AUDIO="-b:a 256K"
	MAP_SET=""
}

p_fhd_mp4_1(){
	AUDIO_COMPLEX=""
	FORMAT_PATH="RSU_HD_MXF/"
	CONTAINER="mxf"
	TRANS_CONT="mxf"
	V_CODEC="mpeg2video"
	A_CODEC="pcm_s16le"
	SETING_VIDEO="-b:v 35M -r 25 -top 1 -flags +ilme+ildct" 
	SETING_AUDIO="-b:a 256K"
	MAP_SET=""
}

p_fhd_mp4_4(){
	AUDIO_COMPLEX="-filter_complex [0:1][0:2][0:3][0:4] amerge=inputs=4,pan=stereo|c0=c0|c1<c1+c2+c3[aout] -map [aout]"
	FORMAT_PATH="RSU_HD_MXF/"
	CONTAINER="mxf"
	TRANS_CONT="mxf"
	V_CODEC="mpeg2video"
	A_CODEC="pcm_s16le"
	SETING_VIDEO="-b:v 35M -r 25 -top 1 -flags +ilme+ildct"
	SETING_AUDIO="-b:a 256K"
	MAP_SET="-map 0:0"
}

p_sd_mts(){
	AUDIO_COMPLEX=""
	FORMAT_PATH="IMPORT_EDITOR/"
	CONTAINER="mov"
	TRANS_CONT="mxf"
	V_CODEC="dvvideo"
	A_CODEC="pcm_s16le"
	SETING_VIDEO="-s 720x576 -vf crop=in_w-2*222"
	SETING_AUDIO="-b:a 256K"
	MAP_SET=""
}

p_sd_mp4_1(){
	AUDIO_COMPLEX=""
	FORMAT_PATH="IMPORT_EDITOR/"
	CONTAINER="mov"
	TRANS_CONT="mxf"
	V_CODEC="dvvideo"
	A_CODEC="pcm_s16le"
	SETING_VIDEO="-s 720x576 -vf crop=in_w-2*222" 
	SETING_AUDIO="-b:a 256K"
	MAP_SET=""
}

p_sd_mp4_4(){
	AUDIO_COMPLEX="-filter_complex [0:1][0:2][0:3][0:4] amerge=inputs=4,pan=stereo|c0=c0|c1<c1+c2+c3[aout] -map [aout]"
	FORMAT_PATH="IMPORT_EDITOR/"
	CONTAINER="mov"
	TRANS_CONT="mxf"
	V_CODEC="dvvideo"
	A_CODEC="pcm_s16le"
	SETING_VIDEO="-s 720x576 -vf crop=in_w-2*222"
	SETING_AUDIO="-b:a 256K"
	MAP_SET="-map 0:0"
}

format_check(){
	END_RESOLUTION=$(echo $end_file_name | awk -F. '{print $NF}')
	media_info_name=$(ls -1 $source_path$end_file_name | sed -n -e 1p)
	CONTAINER_TYPE=$(echo $source_path$end_file_name/$media_info_name | awk -F. '{print $NF}')
	media_info_stp=$(mediainfo $source_path$end_file_name/$media_info_name | grep Audio | wc -l)

	s_wc=$(ls -1 $source_path$end_file_name | wc -l)

	if [[ $END_RESOLUTION == "SD" ]]; then
		log_info "\e[1;32m $FIN_FORM_TXT \e[1;93m $END_RESOLUTION \e[0m"
		
		if [[ "$media_info_stp" -eq "1" ]]; then
			if [[ $CONTAINER_TYPE != "MP4" ]]; then
				p_sd_mts
			else
				p_sd_mp4_1
			fi
		elif [[ "$media_info_stp" -eq "4" ]]; then
			p_sd_mp4_4
		else
			log_info "\e[1;31m $no_profile \e[0m "
			log_copy
			return 1
		fi

	elif [[ $END_RESOLUTION == "FHD" ]]; then
		log_info "\e[1;32m $FIN_FORM_TXT \e[1;93m $END_RESOLUTION \e[0m"
		
		if [[ "$media_info_stp" -eq "1" ]]; then
			
			if [[ $CONTAINER_TYPE != "MP4" ]]; then
				p_fhd_mts
			else
				p_fhd_mp4_1
			fi

		elif [[ "$media_info_stp" -eq "4" ]]; then
			p_fhd_mp4_4
		else
			log_info "\e[1;31m $no_profile \e[0m "
			log_copy
			return 1
		fi

	else
		log_info "\e[1;31m $no_profile \e[0m "
		log_copy
		return 1
	fi
}