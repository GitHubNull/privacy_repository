#!/bin/sh
config_file=./.rr_config
my_iv=562e17996d093d28ddb3ba695a2e6f58

# local repository config
local_repository_name=""
local_repository_pwd=""

# remote repository config
remote_repository_name=""
remote_repository_user_name=""
remote_repository_user_pwd=""
remote_repository_link=""

if [ $# -gt 0 ]; then
    main()
fi

function main()
{
    clear
    echo "=============================\n"
    echo "c.创建私密仓库。                              create\n"
    echo "p.推送本地私密仓库到云端。                    push\n"
    echo "g.获取云端私密仓库。                          get\n"
    echo "d.解密当前目录下的私密仓库。                  decode\n"
    echo "e.加密当前目录下的私密仓库。                  encrypt\n"
    echo "q.退出。                                      quit\n"
    echo "=============================\n"
    read -t 15 -n 1 "请输入您的选择：" choose
    if [ "$choose"x = "c"x || "$choose"x = "C"x ]; then
        create()
    elif [ "$choose"x = "p"x || "$choose"x = "P"x ]; then
        push()
    elif [ "$choose"x = "g"x || "$choose"x = "G"x ]; then
        get()
    elif [ "$choose"x = "d"x || "$choose"x = "D"x ]; then
        decode()
    elif [ "$choose"x = "e"x || "$choose"x = "E"x ]; then
        encrypt()
    else
        exit 0
    fi
}

function create()
{
    read -p "仓库名：" repository_name
    git init local_repository_name
    if [ $? -eq 0 ]; then
        cd $local_repository_name
        mkdir rr_home
        mkdir .rr_home
        read -p "密码：" local_repository_pwd
        initial_config_file(local_repository_name, local_repository_pwd)
        return 0
    else
        exit 1
    fi
}

function decode()
{
    read -p "请输入密码：" tmp_pwd
    read_config_file(config_file, tmp_pwd)


}

function read_config_file(config_file, conf_pwd)
{
    decode_config_file(config_file, conf_pwd)
    if [ $? -eq 0 ]; then 
        source tmp.txt
        if [ $? -eq 0 ]; then
            rm ./tmp.txt
            return $?
        else
            rm ./tmp.txt
            return 1
        fi
    else
        return 1
    fi
}

function encrypt_config_file(config_file, conf_pwd)
{
    openssl enc -aes-256-cbc -salt -in ${config_file} -K $conf_pwd -iv $my_iv -out ${config_file}
    return $?
}

function decode_config_file(config_file, conf_pwd)
{
    openssl enc -aes-256-cbc -d -salt -in ${config_file} -K $conf_pwd -iv $my_iv -out tmp.txt
    return $?
}


function initial_config_file(local_repository_name, local_repository_pwd)
{
    echo "local_repository_name="$local_repository_name"\n" >config_file
    echo "local_repository_pwd="$local_repository_pwd"\n" >>config_file
    return encrypt_config_file(config_file, local_repository_pwd)
}
