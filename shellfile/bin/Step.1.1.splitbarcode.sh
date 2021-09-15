#usr!/bin/
# -N source.sh

helpdoc(){
        cat<<EOF
Usage:
        Preparing for  short assembly
	Using splitbarcode.sh
Option:
        -d <The folder of preparedata>
	-1 <The shortreads1 >
	-2 <The shortreads2 >
	-t <The tools path>
EOF
}


while getopts ":d:1:2:t:h" opt
do
        case $opt in
                d) preparefolder=$OPTARG;;
		1) shortreads1=$OPTARG;; 
		2) shortreads2=$OPTARG;;
		t) atools=$OPTARG;;
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
mkdir $preparefolder
cd $preparefolder
perl $atools/split_barcode.pl $atools/barcode_list.txt $shortreads1 $shortreads2 split_reads

