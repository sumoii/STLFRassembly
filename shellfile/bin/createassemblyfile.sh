#usr!/bin/
# -N cp&&gzip

helpdoc(){
	cat<<EOF
Usage:
	Creating the folder and preparing for assemble
Option:
	-l <The long contigs file path>
	-s <The short(long) contigs file path>
	-1 <The first name of your contigs prefix>
	-2 <The other name of your contigs prefix> 
	-m <The model of Wengan that you choose>
EOF
}


while getopts ":s:l:1:2:m:h" opt
do
        case $opt in
		1) name1=$OPTARG;;
		2) name2=$OPTARG;;
		m) model=$OPTARG;;
                s) shortfile=$OPTARG ;;
		l) longfile=$OPTARG;;
                h|help) helpdoc exit 1 ;;
                ?) echo "$OPTARG Unknown parameter"
                exit 1;;
        esac
done

if [ $# = 0 ]
then
    helpdoc
    exit 1
fi

longfile=$longfile
shortfile=$shortfile

mkdir ${name1}_${name2}_${model}_assemble
cd ${name1}_${name2}_${model}_assemble

str1=$longfile
str2=$shortfile

echo "the sh is run..."

if [[ $str1 =~ .gz  ]]
then
	longfile=${str1}
else
	cp ${str1} ${str1##*/}
	gzip ${str1##*/}
	longfile=${str1##*/}.gz
fi

if [[ $str2 =~ .gz ]]
then
	shortfile=${str2}
else
	cp ${str2} ${str2##*/}
	gzip ${str2##*/}
	shortfile=${str2##*/}.gz
fi


echo "done"
