#!usr/bin
# -N couldspades.sh

helpdoc(){
        cat<<EOF
Usage:
        Shortread assembly of stlfr clean data
Option:
        -f <The 10x fastq file path>
	-t <The threads number> [defualt : 40]
	-o <The output folder path>
	-c <The cloudspades path> 
	-m <The memory GB> [defualt : 250]
EOF
}


while getopts ":c:t:f:m:o:h" opt
do
        case $opt in
               	c) cloudspades=$OPTARG;;
		f) file=$OPTARG;;
		t) threads=$OPTARG;;
		o) output=$OPTARG;;
		m) memory=$OPTARG;;
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

if [ $threads == NULL ]
then
    threads="40"
fi

if [ $memory == NULL ]
then
    memory="250"
fi

mkdir $output
cd $output

$cloudspades --gemcode1-12 $file -o cloudspades_out -t $threads -m $memory
