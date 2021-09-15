#!usr/bin
# -N quast

helpdoc(){
cat << EOF
Description:

        MetastLFRassembled genomic binning

Option:
        -1 The clean.reads1.gz 
        -2 The clean.reads2.gz
	-a The assembled fasta
	-o The output directory
	-M The binning procedure path
	-c Integrity threshold
	-x Pollution rate threshold
	-t The threads number
	-l minimum contig length to bin (default=1000bp)
EOF
}

while getopts ":1:2:a:o:M:c:x:l:t:h help" opt
do
        case $opt in
                1) cleanshortreads1=$OPTARG ;;
                2) cleanshortreads2=$OPTARG ;;
		a) assembled=$OPTARG;;
		o) output=$OPTARG;;
		M) binning=$OPTARG;;
		t) threads=$OPTARG;;
		c) Integrity=$OPTARG;;
		x) Pollution=$OPTARG;;
		l) minimum=$OPTARG;;
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
export PATH=$binning/bin:$PATH

gzip -dc $cleanshortreads1 >reads_1.fastq
gzip -dc $cleanshortreads2 >reads_2.fastq
$binning/bin/metawrap binning -o INITIAL_BINNING  -t $threads --metabat2 --maxbin2 --concoct -l $minimum -a $assembled reads_1.fastq reads_2.fastq
$binning/bin/metawrap bin_refinement -o BIN_REFINEMENT -t $threads -A INITIAL_BINNING/metabat2_bins/ -B INITIAL_BINNING/maxbin2_bins/ -C INITIAL_BINNING/concoct_bins/ -c $Integrity -x $Pollution
rm reads_1.fastq
rm reads_2.fastq
echo "binning done!"

