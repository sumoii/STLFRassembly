#!usr/bin
# -N couldspades.sh

helpdoc(){
        cat<<EOF
Usage:
        Shortread assembly of stlfr clean data
Option:
        -f <The 10x fastq file floder path>
	-t <The threads number> [defualt : 40]
	-o <The output folder path>
	-c <The cloudspades path>
	-l <The longranger path>
	-m <The memory GB> [defualt : 250]
EOF
}


while getopts ":c:l:t:f:m:o:h" opt
do
        case $opt in
               	c) cloudspades=$OPTARG;;
		f) file=$OPTARG;;
		t) threads=$OPTARG;;
		o) output=$OPTARG;;
		m) memory=$OPTARG;;
		l) longranger=$OPTARG;;
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

if [ -z $threads ]
then
    threads="40"
fi

if [ -z $memory ]
then
    memory="250"
fi

mkdir $output
cd $output

${longranger} basic --localcores=$threads --localmem=$memory --id=longranger --fastqs=$file 

$cloudspades --gemcode1-12 longranger/outs/barcoded.fastq.gz -o cloudspades_out -t $threads -m $memory
