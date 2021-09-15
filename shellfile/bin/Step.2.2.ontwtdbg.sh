#!usr/bin
# -N WTDBG

helpdoc(){
cat << EOF
Description:
        
	WTDBG assembly of longreads

Option:
        -l The longreds.fa.gz path
	-o output directory
	-w The WTDBG path
	-t The threads number
	-x The longread format
EOF
}

while getopts ":l:o:w:h help" opt
do
        case $opt in
		l) longreads=$OPTARG;;
                o) output=$OPTARG;;
		w) wtdbg=$OPTARG;;
		t) threads=$OPTARG;;
		x) format=$OPTARG;;
                h | help) helpdoc exit 1;;
                ?) echo "$OPTARG Unknown parameter"
                exit 1
                ;;
        esac
done

if [ $# = 0 ]
then
   helpdoc
   exit 1
fi


mkdir $output
cd $output

$wtdbg/wtdbg2  -t $threads -x $format -g 12g -fo WTDBG -i $longreads
$wtdbg/wtpoa-cns -t $threads -i WTDBG.ctg.lay.gz -fo WTDBG.fa
