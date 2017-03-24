#!/bin/sh
myhome=../../home/*
enc_myhome=../../.home/
tar_format=".tar.gz"
#enc_suffix=".enc"
my_iv=562e17996d093d28ddb3ba695a2e6f58

read -p "请输入密码：" pwd

for file in $myhome
do
    if test -f $file 
    then
        #echo $file 是文件,直接加密
        tmp=${file##*/}
        openssl enc -aes-256-cbc -salt -in ${file} -K $pwd -iv $my_iv -out ${enc_myhome}${tmp}
    fi
    if test -d $file 
    then
        #echo $file 是文件夹,先压缩再加密
        tmp=${file##*/}
        tar -P -zcf ${file}${tar_format} ${file}
        openssl enc -aes-256-cbc -salt -in ${file}${tar_format} -K $pwd -iv $my_iv -out ${enc_myhome}${tmp}${tar_format}
        rm ${file}${tar_format}
    fi
done
