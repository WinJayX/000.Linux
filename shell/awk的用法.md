1.	awk '{print "git.nercoa.com/"$0}' filename
#对Filename 文件的每行前面插入“git.nercoa.com/”字符串

2.	sed -i 's/$/.git/g' filename
#追加.git到每行末尾; $为末尾符号，s代表替换末尾为.git

3.awk '{print "xxx"$0}' fileName
#shell给一个文件中的每一行开头插入字符的方法
awk '{print $0"xxx"}' fileName
#shell给一个文件中的每一行结尾插入字符的方法
awk '$O=$O" xxx"' fileName
#shell给一个文件中的每一行的指定列插入字符的方法