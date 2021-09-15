#!usr/bin
# -N source.sh

helpdoc(){
        cat<<EOF
Usage:
        Input file list 
Option:
        -l <The long reads file path>
        -1 <The 1.fa.gz short read>
        -2 <The 2.fa.gz short read>
	-s <The environment file> 
EOF
}


while getopts ":l:1:2:h" opt
do
        case $opt in
                1) shortreads1=$OPTARG;;
                2) shortreads2=$OPTARG;;
                l) longreads=$OPTARG;;
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

toolspath=`echo $(readlink -f ${BASH_SOURCE[0]})`
atools=${toolspath%/*}
atools=${atools%/*}/tools
