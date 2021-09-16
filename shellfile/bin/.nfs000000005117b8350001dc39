#!usr/bin
# -N getcleandata.sh

helpdoc(){
        cat<<EOF
Usage:
        Getting clean data
Option:
        -t <The tools path>
	-d <The dataprepare path>
	-F adapter sequence for read1,default: AGATCGGAAGAGCGGTTCAGCAGGAATGCCGAG
	-R adapter sequence for read2,default: AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT
	-M how to filter low quality reads? 0 for no filtering, 1 for native quality reads mode, 2 for read-end quality masking by EAMSS algorithm(mask B); default: 0
	-y filter reads with adapter
	-n thread number, default: 8
	-Q the maximum low quality value, default: 7
	-f trim flag:-1 for no trimming, 0 for unify trimming, 1 for trimming min(maskB length,-b/-d);default: 0
	-p filter PCR duplication
    		-s<int>   trimmed length at 5' end of read1 when distinguishing duplication, default: 0
    		-l<int>   the sub-length of read1 used to distinguish duplication,-1 for whole read, default: -1
    		-S<int>   trimmed length at 5' end of read2 when distinguishing duplication, default: 0
    		-L<int>   the sub-length of read2 used to distinguish duplication,-1 for whole read, default: -1

EOF
}


while getopts ":d:t:n:F:R:M:Q:f:h y p" opt
do
        case $opt in
                t) atools=$OPTARG;;
		d) dataprepare=$OPTARG;;
		n) number=$OPTARG;;
		F) adapter1=$OPTARG;; 
		R) adapter2=$OPTAGR;;
		M) Method=$OPTARG;;
		y) ya=-y;;
		f) fa=$OPTARG;;
		p) pa=-p;;
		Q) mlow=$OPTARG;;
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

cp $atools/lane.lst  $dataprepare/lane.lst
cd $dataprepare
$atools/SOAPfilter_v2.2 -t $number -F $adapter1 -R $adapter2 $ya $pa -M $Method -f $fa -Q $mlow lane.lst stat.txt
