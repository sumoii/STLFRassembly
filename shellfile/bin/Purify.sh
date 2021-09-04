#!usr/bin
# -N Purify
helpdoc(){
cat << EOF
Description:
        Purify of Quast report

Option:
        -p the path of Purify
	-r the path of assembled genomic
	-1 the name of set before
	-2 the name of set before
	-m the model of set before
EOF
}

while getopts ":p:r:1:2:m:h help" opt
do
        case $opt in
                p) path=$OPTARG ;;
		r) assembled=$OPTARG;;
		1) name1=$OPTARG;;
		2) name2=$OPTARG;;
		m) model=$OPTARG;;
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

mkdir  ${name1}_${name2}_${model}_Purify
cd  ${name1}_${name2}_${model}_Purify
cp ../${name1}_${name2}_${model}_quast/filename.txt filename.txt

echo "run..."
while read line 
do
python3 $path \
-rawContig ../$assembled \
-purifySeq  $line\.fasta \
-quastAlnTsv ../${name1}_${name2}_${model}_quast/$line\.quast/contigs_reports/all_alignments_${name1}_${name2}-SPolished-asm-wengan.tsv
echo "......"
done < filename.txt

echo "done"
