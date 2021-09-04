#!usr/bin
# -N pre_quast
helpdoc(){
cat << EOF
Description:
	Prepare for quast

Option:
	-r The path of reference genomic
        -1 <The first name of your contigs prefix>
        -2 <The other name of your contigs prefix>
	-m The model you choose
EOF
}

while getopts ":f:r:1:2:m:h help" opt
do
        case $opt in
                r) ref=$OPTARG ;;
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
ref=$ref

mkdir ${name1}_${name2}_${model}_quast
cd ${name1}_${name2}_${model}_quast
echo $ref
ls $ref | sed "s:^:$ref/:" >genomic.txt
