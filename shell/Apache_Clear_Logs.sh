#! /bin/bash
logdir=/var/log/apache2
cd ${logdir}
# declare命令用于声明和显示已存在的shell变量。
# 当不提供变量名参数时显示所有shell变量。
# declare命令若不带任何参数选项，
# 则会显示所有shell变量及其值。
# declare的功能与typeset命令的功能是相同的。
declare -i filesum=`ls error* | wc -l`
declare -i delnum=$filesum-1
if [ "${delnum}" -ge 1 ];then
rm -rf `ls -tr error* | head -${delnum}`
fi
