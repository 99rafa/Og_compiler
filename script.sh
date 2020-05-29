#!/bin/sh

#Folder where the tests are located
TEST_FOLDER="../auto-tests"

#local directory to rts
RTS_LIB="home/rafael/compiladores/root/usr/lib"	

#path to expected results
EXPECTED=$TEST_FOLDER/expected

#results folder
RESULTS_FOLDER="../results"


#change to see or not result colors
COLOR=true

SUCCESS=2
TOTAL=0

mkdir -p $RESULTS_FOLDER


if [ "$COLOR" = true ]; then
    BOLD="\e[1m"
    DEFAULT="\e[0m"
	BLUE="\e[96m"
	YELLOW="\e[93m"
	RED="\e[91m"
	GREEN="\e[92m"
fi



for file in $TEST_FOLDER/*.og
do
    echo ""
	TOTAL=$(($TOTAL + 1))

	filename="$file"
	fileprefix="${filename%.*}"
	fileI=$( echo $fileprefix | sed 's/^.*auto-tests/auto-tests/')
	filesufix="${fileI#*/}"

	./og -g "$file"
	yasm -felf32 $fileprefix.asm
	ld -melf_i386 -o $RESULTS_FOLDER/$filesufix $filesufix.o -L/$RTS_LIB -lrts
    ./$RESULTS_FOLDER/$filesufix > output.txt


    if diff -w -b "$EXPECTED/$filesufix.out" "output.txt" >/dev/null 2>&1;

    then 	echo "${GREEN}Test $filesufix passed${DEFAULT}"
 	        SUCCESS=$(($SUCCESS + 1))	

    else 
	        echo "${RED}Test $filesufix failed"
	        expected=$(cat $EXPECTED/$filesufix.out)
	        got=$(./$RESULTS_FOLDER/$filesufix)
	        echo "expected: '${expected}'"
            echo "got: '${got}'${DEFAULT}"

    fi

    rm $filesufix.o
    rm output.txt

done

perc=$(echo "scale=2; $SUCCESS*100/$TOTAL" | bc -l)

if [ $(echo "$perc > 50" | bc -l ) -eq 0 ] ; then color=$RED

elif [ $(echo "$perc == 100" | bc -l ) -eq 0 ] ; then color=$YELLOW

else color=$GREEN

fi

echo  "\n${BOLD}FINAL RESULTS: ${DEFAULT}${color}$SUCCESS tests passed out of $TOTAL total. Percentage = $perc%"
 

