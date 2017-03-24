#!/bin/sh
myhome=../../home/
enc_myhome=../../.home/*
tar_format=".tar.gz"
#enc_suffix=".enc"
my_iv=562e17996d093d28ddb3ba695a2e6f58

read -p "请输入密码：" pwd

for file in $enc_myhome
do
    tmp_path=${file##*/}
    tmp=${tmp_path#*.}
    if [ "$tmp"x = "tar.gz"x ];
    then
        #echo $file 是文件夹,先解密，再解压缩
        tmp1=${file##*/}
        tmp2=${tmp1%%.*}
        openssl enc -aes-256-cbc -d -salt -in ${file} -K $pwd -iv $my_iv -out ${myhome}${tmp1}
        tar -P -xzf ${myhome}${tmp1} ${myhome}${tmp2}
        rm ${myhome}${tmp1}
    else 
        #echo $file 是文件,直接解密
        tmp1=${file##*/}
        openssl enc -aes-256-cbc -d -salt -in ${file} -K $pwd -iv $my_iv -out ${myhome}${tmp1}
    fi
done
