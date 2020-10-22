cat 1 | sed -e ' s/http:\/\///' -e ' s/\/.*//' | sort |uniq -c | sort -rn


awk -F/ '{print $3}' 1 |sort -r|uniq -c|awk '{print$1"\t",$2}'
awk -F/ '{print $3}' file |sort -r|uniq -c|awk '{print$1"\t",$2}'

	



