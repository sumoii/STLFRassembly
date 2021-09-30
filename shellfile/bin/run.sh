#usr!/bin/
# -N source.sh
helpdoc()
{ cat <<EOF
	-l   The longread path
	-1   The shortreads1 path
	-2   The shortreads2 path
	-f   The first pirfix [default: STLFR_CLOUDSPADES ]
	-s   The other pirfix [default: WTDBG ]
	-t   The threads number
	-m   The model of Wengan
	-c   The cloudspades path
	-w   The wtdbg path
	-g   The memory of set
	-x   The longreads format [default : ont]
	-W   The whitelist path
	-L   The longranger path
	-M   The methed of you choose  [Quast or Binning]
		Quast The quast way
			require the follow options
			-r   The reference path
			-q   The quast path
		Binning The binning way
			require the follow options
			-b   The binning path (MeatWRAP)
	-A   Choose of all methed (binning and quast)
EOF
}

while getopts ":l:1:2:f:s:t:c:w:m:g:x:W:L:M:r:q:b: A h" opt
do
        case $opt in
		l) longreads=$OPTARG;;
		1) shortreads1=$OPTARG;;
		2) shortreads2=$OPTARG;;
		f) name1=$OPTARG;;
		s) name2=$OPTARG;;
		t) threads=$OPTARG;;
		c) cloudspades=$OPTARG;;
		w) wtdbg=$OPTARG;;
		m) model=$OPTARG;;
		g) memory=$OPTARG;;
		x) format=$OPTARG;;
		W) whitelist=$OPTARG;;
		L) longranger=$OPTARG;;
		r) reference=$OPTARG;;	
		q) quast=$OPTARG;;
		b) binning=$OPTARG;;
		M) method=$OPTARG;;
		A) allmethod=right;;
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

if [ -z $name1 ]
then
    name1="STLFR_CLOUDSPADES"
fi

if [ -z $name2 ]
then
    name2="WTDBG"
fi

if [ -z $format ]
then
    format="ont"
fi

if [ -z $cloudspades ]
then
    echo "The path of cloudespades are required"
    exit 1
fi

if [ -z $wtdbg ]
then
    echo "The path of WTDBG are required"
    exit 1
fi

if [ -z $model ] 
then
    echo "The model of Wengan are requried"
    exit 1
fi

if [ "$allmethod" == "right" ]
then
    if [ -z $reference ]
    then
        echo "The reference file folder are required"
        exit 1
    fi
    if [ -z $quast ]
    then
        echo "The quast path are required"
        exit 1
    fi
    if [ -z $binning ]
    then
        echo "The binning path are required"
        exit 1
    fi
fi


if [ "$method" = "Quast" ] 
then
    if [ -z $reference ]
    then
	echo "The reference file folder are required"
        exit 1
    fi
    if [ -z $quast ]
    then
	echo "The quast path are required"
	exit 1
    fi
fi

if [ "$method" = "Binning" ]
then
    if [ -z $binning ]
    then
	echo "The binning path are required"
	exit 1
    fi
fi


echo `date` Step.1.0.getsource.sh running >>time.log
source Step.1.0.getsource.sh \
-l $longreads  \
-1 $shortreads1  \
-2 $shortreads2
echo `date` Step.1.0.getsource.sh end >>time.log

if [ `grep -c "Step.1.0.getsource.sh end" time.log` -eq '0' ]
then 
    echo "The Step.1.0.getsource.sh error please cecheck the log file"
    exit 1
fi

echo "################################" >>time.log

echo `date` Step.1.1.splitbarcode.sh running >>time.log
sh Step.1.1.splitbarcode.sh -d Dataprepare -1 $shortreads1 -2 $shortreads2 -t $atools > splitbarcode.log
echo `date` Step.1.1.splitbarcode.sh end >>time.log

if [ `grep -c "Step.1.1.splitbarcode.sh end" time.log` -eq '0' ]
then
   echo "The Step.1.1.splitbarcode.sh error please cecheck the log file"
   exit 1
fi

echo "################################" >>time.log
echo `date` Step.1.2.getcleandata.sh running >>time.log
sh Step.1.2.getcleandata.sh -t $atools  -d Dataprepare -F CTGTCTCTTATACACATCTTAGGAAGACAAGCACTGACGACATGA -R TCTGCTGAGTCGAGAACGTCTCTGTGAGCCAAGGAGTTGCTCTGG -y -p -M 2 -f -1 -Q 10 -n $threads > cleandata.log
echo `date` Step.1.2.getcleandata.sh end >>time.log

if [ `grep -c "Step.1.2.getcleandata.sh end" time.log` -eq '0' ]
then 
    echo "The Step.1.2.getcleandata.sh error please cecheck the log file"
    exit 1
fi

echo "#################################" >>time.log
echo `date` Step.1.3.stlfrto10x.sh running >>time.log
sh Step.1.3.stlfrto10x.sh -a $atools -1 `pwd`/Dataprepare/split_reads.1.fq.gz.clean.gz -2 `pwd`/Dataprepare/split_reads.2.fq.gz.clean.gz \
-t $threads -w $whitelist  -f 2 -m 8 -M $memory 
echo `date` Step.1.3.stlfrto10x.sh end >>time.log

if [ `grep -c "Step.1.3.stlfrto10x.sh end" time.log` -eq '0' ]
then
    echo "The Step.1.3.stlfrto10x.sh error please cecheck the log file"
    exit 1
fi

echo "###############################" >>time.log
echo `date` Step.2.1.stlfrcloudspades.sh running >>time.log
sh Step.2.1.stlfrcloudspades.sh -t $threads -f `pwd`/STLFR10X/reads_floder \
-o ${name1}_contigs \
-c ${cloudspads} \
-m ${memory} \
-l ${longranger} >shortassembly.log

echo `date` Step.2.1.stlfrcloudspades.sh end >>time.log

if [ `grep -c "Step.2.1.stlfrcloudspades.sh end" time.log` -eq '0' ]
then
    echo "The Step.2.1.stlfrcloudspades.sh error please cecheck the log file"
    exit 1
fi

echo "###############################" >>time.log
echo `date` Step.2.2.ontwtdbg.sh running >>time.log
sh Step.2.2.ontwtdbg.sh  -w $wtdbg -t $threads -x $format \
-l $longreads  \
-o ${name2}_contigs > longassembly.log
echo `date` Step.2.2.ontwtdbg.sh end >>time.log

if [ `grep -c "Step.2.2.ontwtdbg.sh end" time.log` -eq '0' ]
then
    echo "The Step.2.2.ontwtdbg.sh error please cecheck the log file"
    exit 1
fi

echo "###############################" >>time.log
echo `date` Step.3.1.wenganaseembly.sh running >>time.log
sh Step.3.1.wenganaseembly.sh -l $longreads  \
-s `pwd`/Dataprepare/split_reads.1.fq.gz.clean.gz,`pwd`/Dataprepare/split_reads.2.fq.gz.clean.gz \
-f `pwd`/${name1}_contigs/cloudspades_out/contigs.fasta  \
-d ${name2}_contigs/WTDBG.fa  \
-1 ${name1} -2 ${name2} -m ${model} -t 20 -g 3000 -x ontraw >wenganassemble.log 
echo `date` Step.3.1.wenganaseembly.sh end >>time.log

if [ `grep -c "Step.3.1.wenganaseembly.sh end" time.log` -eq '0' ]
then
    echo "The Step.3.1.wenganaseembly.sh error please cecheck the log file"
    exit 1
fi


if [ $allmethod = "right"  ];
then
	echo "###############################" >>time.log
	echo `date` Step.4.1.1.prequast.sh running >>time.log
	sh Step.4.1.1.prequast.sh \
	-r $reference \
	-1 ${name1} -2 ${name2} -m ${model}
	echo `date` Step.4.1.1.prequast.sh end >>time.log

	echo "###############################" >>time.log
	echo `date` Step.4.1.2.quast.sh running >>time.log
	cd ${name1}_${name2}_${model}_quast
	sh Step.4.1.2.quast.sh \
	-f ../${name1}_${name2}_${model}_assemble/${name1}_${name2}.SPolished.asm.wengan.fasta \
	-q $quast >quast.log
	cd ..
	echo `date` Step.4.1.2.quast.sh end >>time.log

	echo "###############################" >>time.log
	echo `date` Step.4.1.3.purify.sh running >>time.log
	sh Step.4.1.3.purify.sh \
	-p ${atools}/contig_purify.py \
	-r ../${name1}_${name2}_${model}_assemble/${name1}_${name2}.SPolished.asm.wengan.fasta \
	-1 ${name1} -2 ${name2} -m ${model} > purify.log
	echo `date` Step.4.1.3.purify.sh end >>time.log

	echo "###############################" >>time.log
	echo `date` Step.4.1.4.afterpurifyquast.sh running >>time.log
	sh Step.4.1.4.afterpurifyquast.sh  \
	-1 ${name1} -2 ${name2} -m ${model} \
	-p ${quast} > quastafterpurify.log
	echo `date` Step.4.1.4.afterpurifyquast.sh end >>time.log

	echo "##############################" >> time.log
	echo `date` Step.4.2.1.binning.sh running >>time.log
	sh Step.4.2.1.binning.sh -1 Dataprepare/split_reads.1.fq.gz.clean.gz -2 Dataprepare/split_reads.2.fq.gz.clean.gz  \
        -o ${name1}_${name2}_${model}_binning \
        -M $binning -c 50 -x 10 -t $threads -l 1000

exit 1

fi

if [ $method = "Quast"  ]
then
	echo "###############################" >>time.log
	echo `date` Step.4.1.1.prequast.sh running >>time.log
	sh Step.4.1.1.prequast.sh \
	-r $reference \
	-1 ${name1} -2 ${name2} -m ${model} 
	echo `date` Step.4.1.1.prequast.sh end >>time.log

	echo "###############################" >>time.log
	echo `date` Step.4.1.2.quast.sh running >>time.log
	cd ${name1}_${name2}_${model}_quast
	sh Step.4.1.2.quast.sh \
	-f ../${name1}_${name2}_${model}_assemble/${name1}_${name2}.SPolished.asm.wengan.fasta \
	-q $quast >quast.log
	cd ..
	echo `date` Step.4.1.2.quast.sh end >>time.log

	echo "###############################" >>time.log
	echo `date` Step.4.1.3.purify.sh running >>time.log
	sh Step.4.1.3.purify.sh \
	-p ${purify} \
	-r `pwd`/${name1}_${name2}_${model}_assemble/${name1}_${name2}.SPolished.asm.wengan.fasta \
	-1 ${name1} -2 ${name2} -m ${model} > purify.log
	echo `date` Step.4.1.3.purify.sh end >>time.log

	echo "###############################" >>time.log
	echo `date` Step.4.1.4.afterpurifyquast.sh running >>time.log
	sh Step.4.1.4.afterpurifyquast.sh  \
	-1 ${name1} -2 ${name2} -m ${model} \
	-p ${quast} > quastafterpurify.log 
	echo `date` Step.4.1.4.afterpurifyquast.sh end >>time.log

else 
	echo "##############################" >> time.log
	echo `date` Step.4.2.1.binning.sh running >>time.log
	sh Step.4.2.1.binning.sh -1 `pwd`/Dataprepare/split_reads.1.fq.gz.clean.gz -2 `pwd`/Dataprepare/split_reads.2.fq.gz.clean.gz  \
	-o ${name1}_${name2}_${model}_binning \
	-M $binning -c 50 -x 10 -t $threads -l 1000
	echo `date` Step.4.2.1.binning.sh end >>time.log
fi

