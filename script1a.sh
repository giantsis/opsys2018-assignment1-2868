grep  "^[^#*]" $1 > text1.txt
while read i ;
do
       temporary=$(wget $i -q -O -)
       r=$?
       t="$i"
       t=${t##*\//}
       t="${t////\\}"

       if [ $r -eq 0 ]; then
                if [ ! -f "$t".txt ]; then
                        echo "$i INIT"
                        touch "$t".txt
                        echo $temporary > "$t".txt
                else
                       
                        echo $temporary > "$t1".txt
                        if ! cmp -s "$t".txt "$t1".txt; then
                                 
			   echo	$temporary>"$t".txt
                                 echo "$t"
                         fi
                fi
        else
                echo "FAILED" > "$t".txt
              >&2  echo "$i FAILED"
        fi
done <text1.txt

