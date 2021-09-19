#!usr/bin
helpdoc(){
        cat<<EOF
Usage:
       
	 Preparing for  short assembly
	 STLFR to 10X	

Option:
        -a The tools path
        -1 The split_reads.1.fq.gz.clean.gz path
        -2 The split_reads.1.fq.gz.clean.gz path
        -t The threads numbers [default: 8]
	-w The whitelist path
	-f filter_num [default: 2]
	-m mapratio_num [default: 8]
	-M The memory number GB [default: 40]
EOF
}


while getopts ":a:1:2:t:w:f:m:M:h" opt
do
        case $opt in
                a) atools=$OPTARG;;
                1) r1=$OPTARG;;
                2) r2=$OPTARG;;
                t) threads=$OPTARG;;
		w) whitelist=$OPTARG;;
		f) filter_num=$OPTARG;;
		m) mapratio_num=$OPTARG;;
		M) memory=$OPTARG;;
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
    threads="8"
fi

if [ -z $filter_num ]
then
    filter_num="2"
fi

if [ -z $mapratio_num ]
then
    mapratio_num="8"
fi

if [ -z $memory ]
then
    memory="40"
fi

mkdir STLFR_10X 
cd STLFR_10X

ln -s  $r1  split_reads.1.fq.gz.clean.gz
ln -s  $r2  split_reads.2.fq.gz.clean.gz

sh $atools/shell_barcode

perl $atools/merge_barcodes.pl barcode_clean_freq.txt $whitelist merge.txt  $filter_num  $mapratio_num  1> merge_barcode.log

perl $atools/fake_10x.pl  $r1  $r2  merge.txt  2>fake_10X.err >fake_10X.log


mkdir reads_fastq

mv read-I1_si-TTCACGCG_lane-001-chunk-001.fastq.gz  reads_fastq/sample_S1_L001_I1_001.fastq.gz
mv read-R1_si-TTCACGCG_lane-001-chunk-001.fastq.gz  reads_fastq/sample_S1_L001_R1_001.fastq.gz
mv read-R2_si-TTCACGCG_lane-001-chunk-001.fastq.gz  reads_fastq/sample_S1_L001_R2_001.fastq.gz

