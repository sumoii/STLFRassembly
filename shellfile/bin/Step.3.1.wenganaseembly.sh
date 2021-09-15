#usr!/bin/
# -N cp&&gzip

helpdoc(){
	cat<<EOF
Usage:
	Creating the folder and preparing for assemble
Option:
	-l <The long contigs file path>
	-s <The short(long) contigs file path>
	-f <The first name of your contigs prefix>
	-d <The other name of your contigs prefix> 
	-m <The model of Wengan that you choose>
	-1 <The clean 1.fa.gz>
	-2 <The cleam 2.fa.gz>
	-t <The thread numbers>
	-g <The genomic size>
	-x <The longread preinstall>
EOF
}


while getopts ":s:l:1:2:m:f:d:t:x:g:h" opt
do
        case $opt in
		f) name1=$OPTARG;;
		d) name2=$OPTARG;;
		m) model=$OPTARG;;
                s) shortfile=$OPTARG ;;
		l) longfile=$OPTARG;;
		1) cleanshortreads1=$OPTARG;;
		2) cleanshortreads2=$OPTARG;;
		x) longreadpreinstall=$OPTARG;;
		t) thread=$OPTARG;;
		g) genomicsize=$OPTARG;;
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

perl ${wengan} -x $longreadpreinstall -a $model  \
-s $cleanshortreads1,$cleanshortreads2 \
-l $longfile \
-c $shortfile \
-p ${name1}_${name2} -t $thread -g $genomicsize

echo "done"
