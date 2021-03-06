#!usr/bin
# -N quast

helpdoc(){
cat << EOF
Description:
        Quast of assembled genomic

Option:
        -f The path of assembled file
        -q The path of quast.py
EOF
}

while getopts ":f:q::h help" opt
do
        case $opt in
                f) assembly=$OPTARG ;;
                q) quast=$OPTARG ;;
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
assembly=$assembly

if [ $# = 0 ]
then
    helpdoc
    exit 1
fi

assembly=$assembly
quast=$quast

while read line
do
str=$line
str=${str##*/}
str=${str%.*}
echo $str >> filename.txt
python3 $quast $assembly \
-r $line \
-t 40 \
-o ${str}.quast 
done < genomic.txt

echo ".....................................done!"
