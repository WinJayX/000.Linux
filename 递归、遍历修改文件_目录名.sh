#!/bin/bash
# author:WinJayX
# date:2020-06-19
# Maintainer WinJayX <WinJayX@Gmail.com>
# func:根据安徽电大资源库需求，对1.8T资源数据文件及目录名全部改成小写
# 递归、遍历修改文件/目录名 目录或文件名中带有空格的不支持
# 
function changeName(){
    #new=`echo $1|sed 's/^/abc/g'`
    new=`echo $1|tr [A-Z] [a-z]`
    echo changeName old: $1 new: $new
    if [ $1 != $new ];then
        mv $1 $new
    fi
}

function travFolder(){
    #echo "travFolder start"
    flist=`ls $1`
    cd $1
    for f in $flist
    do
        #echo traverse do $f
        local old=$f
        if test -d $f
        then
            #echo "traverse dir:${f}"
            travFolder $f
            #echo "traverse rename dir:${f}"
            changeName $old #新加的rename文件夹名字
        else
            #echo "traverse file:$f"
            changeName $f
        fi
    done
    cd ../
}

param=$1
if [ -z "$1" ]
    then
    param="./"
    echo "empty string: $param"
else
    param=$1
fi
travFolder $param