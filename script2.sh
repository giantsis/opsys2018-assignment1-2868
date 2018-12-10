#!/bin/bash
rawgiturls="rawgiturlfiles"
assignments="assignments"
mkdir $rawgiturls
[ -d $assignments ] || mkdir $assignments 
tar -xzf $1 -C $rawgiturls

find $rawgiturls -type f -name "*.txt" | while read txtfile
do
	while IFS='' read -r line || [[ -n "$line" ]] 	
	do
		[[ "$line" =~ ^#.*$ ]] && continue	
		if [[ "$line" =~ ^https.*$ ]]	
		then
			
			cd $assignments
			git clone -q $line >/dev/null 2>&1 
			if [ $? -eq 0 ]
				then
				echo $line ": Clone OK"
			else
				echo $line ": Clone FAILED" >&2	
			fi
			
			cd ..
			break	
		fi
	done < "$txtfile"
done


rm -rf $rawgiturls


cd $assignments


for d in *
do
	if [ -d ${d} ]
	then

		echo "$d: "
	
		numberofdirectories=`ls -l $d | grep -c ^d`
		echo "Number of directories: $numberofdirectories."
		
		numberoftxtfiles=`find $d -type f -iname '*.txt'| grep -v '/\.' | wc -l` 
		echo "Number of txt files: $numberoftxtfiles."
		
		numberoffiles=`find $d -type f -iname '*' | grep -v '/\.' | wc -l` 
		numberofotherfiles=$((numberoffiles-numberoftxtfiles))
		echo "Number of other files: $numberofotherfiles."
		
		if [ $numberofdirectories -eq 1 ] && [ $numberoftxtfiles -eq 3 ] && [ $numberofotherfiles -eq 0 ]
		then
			
			if [ `find $d -type f | grep "dataA.txt" | wc -l` -eq 1 ] && [ `find $d -type f | grep "/more/dataB.txt" | wc -l` -eq 1 ] && [ `find $d -type f | grep "/more/dataC.txt" | wc -l` -eq 1 ]
			then
				echo "Director structure is OK."
			else
				echo "Director structure is NOT OK."
			fi
		else
			echo "Director structure is NOT OK."
		fi
	fi
done
