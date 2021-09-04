#usr!/bin/
# -N quast_afterPurify

helpdoc(){
        cat<<EOF
Usage:
        Creating the folder and preparing for assemble
Option:
        -1 <The first name of your contigs prefix>
        -2 <The other name of your contigs prefix>
        -m <The model of Wengan that you choose>
	-p <The path of quast>
EOF
}


while getopts ":m:1:2:p:h help" opt
do
        case $opt in
                1) name1=$OPTARG;;
                2) name2=$OPTARG;;
                m) model=$OPTARG;;
		p) path=$OPTARG;;
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

mkdir ${name1}_${name2}_${model}_quast_afterPurify
cd ${name1}_${name2}_${model}_quast_afterPurify
echo "Running..."
while read line
do 
echo "..."
echo "....."
echo "......."
str=${line##*/}
str=${str%.*}
nohup python3 $path \
../${name1}_${name2}_${model}_Purify/${str}.fasta \
-r $line \
-t 40 \
-o ${str}_afterPurify.quast 2>run.err >run.log &
done < ../${name1}_${name2}_${model}_quast/genomic.txt 
echo "done!"
