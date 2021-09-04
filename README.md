# WENGANassemble of Mockdata


Install Wengan and Create the environment  
-----------------------------------------
Wengan : https://github.com/adigenova/wengan/releases/download/v0.2/wengan-v0.2-bin-Linux.tar.gz
```
$ cd usr/software 
$ wget https://github.com/adigenova/wengan/releases/download/v0.2/wengan-v0.2-bin-Linux.tar.gz
$ tar -zxvf wengan-v0.2-bin-Linux.tar.gz
```
Set the path of wengan
```
$ vi ~/.bashrc
export wengan="usr/software/wengan-v0.2-bin-Linux/wengan.pl"
$ source ~/.bashrc
```
Download the test data and Running test
---------------------------------------
Getting the way of wengan.dome:https://github.com/adigenova/wengan_demo.git

```
$ mkdir usr/workfolder/test
$ cd usr/workfolder/test
$ git clone https://github.com/adigenova/wengan_demo.git
$ cd wengan_demo
$ mkdir WG_M_IN
$ cd WG_M_IN
$ perl ${wengan} -x ontraw -a A -s ../ecoli/reads/EC.50X.R1.fastq.gz,../ecoli/reads/EC.50X.R2.fastq.gz -l \
../ecoli/reads/EC.ONT.30X.fa.gz -p ec_Wa_or1 -t 10 -g 5
```
There are some errors(as Abyss module) or if you have no errors that you may ignore the following 

```
$ le ec_Wm_or1.minia.41.err
/lib64/libstdc++.so.6: version `GLIBCXX_3.4.22' not found (required by /dellfsqd2/ST_OCEAN/USER/xiaogaohong/software/wengan/wengan-v0.2-bin-Linux/bin/minia)
/lib64/libstdc++.so.6: version `CXXABI_1.3.11' not found (required by /dellfsqd2/ST_OCEAN/USER/xiaogaohong/software/wengan/wengan-v0.2-bin-Linux/bin/minia)
/lib64/libstdc++.so.6: version `GLIBCXX_3.4.21' not found (required by /dellfsqd2/ST_OCEAN/USER/xiaogaohong/software/wengan/wengan-v0.2-bin-Linux/bin/minia)
/lib64/libstdc++.so.6: version `CXXABI_1.3.8' not found (required by /dellfsqd2/ST_OCEAN/USER/xiaogaohong/software/wengan/wengan-v0.2-bin-Linux/bin/minia)
/lib64/libstdc++.so.6: version `GLIBCXX_3.4.20' not found (required by /dellfsqd2/ST_OCEAN/USER/xiaogaohong/software/wengan/wengan-v0.2-bin-Linux/bin/minia)
```
That meanings the gcc /lib64/libstdc++.so.6 have no new GLIBCXX_ and CXXABI ,you need update the lib64

If you are not root id that you need download GCC(8.3) and set the lib path

you can get it from : https://ftp.gnu.org/gnu/gcc/gcc-8.3.0/gcc-8.3.0.tar.gz
```
$ cd usr/software
$ wget https://ftp.gnu.org/gnu/gcc/gcc-8.3.0/gcc-8.3.0.tar.gz
$ tar -zxvf gcc-8.3.0.tar.gz
$ cd gcc-8.3.0
$ ./configure prefix = usr/software/GCC
#Multithread compilation
$ make -j4(or more)  
$ make install
```
```
$ vi ~/.bashrc 
export PATH="usr/software/GCC/bin:usr/software/GCC/lib64$PATH"
export LD_LIBRARY_PATH="usr/software/GCC/lib64:usr/software/GCC/lib$LD_LIBRARY_PATH"
$ source ~/.bashrc
```
After that the test can be running well

Hybrid assembly with Wengan
-----------------------------------  
There have some necessary shellfile need to download  
Shellfile : https://github.com/sumoii/WENGANassemble.git
```
bin
|-- afterPurify_quast.sh
|-- createassmbelyfile.sh
|-- pre_quast.sh
|-- Purify.sh
`-- quast.sh
```
```
$ cd usr/software
$ git clone https://github.com/sumoii/WENGANassemble.git
$ vi ~/.bashrc
export PATH="/usr/software/WENGANassemble/shellfile/bin:$PATH"
```
All right ,then we can begin the process 

### Assmeble
```
$ sh createassmbelyfile.sh
Usage:
        Creating the folder and preparing for assemble
Option:
        -l <The long contigs file path>
        -s <The short(long) contigs file path>
        -1 <The first name of your contigs prefix>
        -2 <The other name of your contigs prefix>
        -m <The model of Wengan that you choose A or D>
```
```
$ cd usr/workfolder
$ source createassmbelyfile.sh \
-l usr/Assembly/Mock10.ONTGRID_WTDBG.fa  \
-s usr/Assembly/Mock10.STLFR_CLOUDSPADES.fa  \
-1  STLFR_CLOUDSPADES -2 WTDBG -m A
```
```
$ nohup perl ${wengan} -x ontraw -a $model  \
-s usr/database/R10_stLFR/split_reads.1.fq.gz.clean.gz,usr/database/R10_stLFR/split_reads.2.fq.gz.clean.gz \
-l $longfile \
-c $shortfile \
-p ${name1}_${name2} -t 40 -g 3000  2>run_err.txt >run.log &
$ cd ..
```
### Quast
```
$ sh pre_quast.sh 
Description:
        Prepare for quast
Option:
        -r The path of reference genomic
        -1 <The first name of your contigs prefix>
        -2 <The other name of your contigs prefix>      
        -m The model you choose  
        
$ sh pre_quast.sh -r usr/database/mock10_kraken2-fa -1 ${name1} -2 ${name2} -m ${model}
$ cd ${name1}_${name2}_${model}_quast
```
```
$ sh quast.sh
Description:
        Quast of assembled genomic
        
Option:
        -f The path of abssebly file
        -q The path of quast.py  
        
$ sh quast.sh \
-f ../${name1}_${name2}_${model}_assemble/${name1}_${name2}.SPolished.asm.wengan.fasta \
-q usr/software/quast/quast.py
$ cd ..
```
### Purify
```
$ sh Purify.sh
Description:
        Purify of Quast report

Option:
        -p the path of Purify
        -r the path of assembled genomic
        -1 <The first name of your contigs prefix>
        -2 <The other name of your contigs prefix>
        -m the model of set before
```
```
$ sh Purify.sh -p /dellfsqd2/ST_OCEAN/USER/xiaogaohong/software/contig_purify.py \
-r ${name1}_${name2}_${model}_assemble/${name1}_${name2}.SPolished.asm.wengan.fasta  \
-1 $name1 -2 $name2 -m $model
```
### Quast after Purify
```
$ sh afterPurify_quast.sh
Usage:
        Quast after Purify
Option:
        -1 <The first name of your contigs prefix>
        -2 <The other name of your contigs prefix>
        -m <The model of Wengan that you choose>
        -p <The path of quast>
 
$ sh afterPurify_quast.sh -1 $name1 -2 $name2 -m ${model} -p usr/software/quast/quast.py
```
### Result
```
$ tree -L 1
.
|-- STLFR_CLOUDSPADES_WTDBG_A_assemble
|-- STLFR_CLOUDSPADES_WTDBG_A_Purify
|-- STLFR_CLOUDSPADES_WTDBG_A_quast
`-- STLFR_CLOUDSPADES_WTDBG_A_quast_afterPurify
```

```
|   `-- STLFR_CLOUDSPADES_WTDBG.SPolished.asm.wengan.fasta
|-- STLFR_CLOUDSPADES_WTDBG_A_Purify
|   |-- 1280_genomic.fasta
|   |-- 1351_genomic.fasta
|   |-- 1423_genomic.fasta
|   |-- 1613_genomic.fasta
|   |-- 1639_genomic.fasta
|   |-- 287_genomic.fasta
|   |-- 28901_genomic.fasta
|   |-- 4932_genomic.fasta
|   |-- 5207_genomic.fasta
|   |-- 562_genomic.fasta
|   `-- filename.txt
|-- STLFR_CLOUDSPADES_WTDBG_A_quast
|   |-- 1280_genomic.quast
|   |-- 1351_genomic.quast
|   |-- 1423_genomic.quast
|   |-- 1613_genomic.quast
|   |-- 1639_genomic.quast
|   |-- 287_genomic.quast
|   |-- 28901_genomic.quast
|   |-- 4932_genomic.quast
|   |-- 5207_genomic.quast
|   |-- 562_genomic.quast
|   |-- filename.txt
|   `-- genomic.txt
`-- STLFR_CLOUDSPADES_WTDBG_A_quast_afterPurify
    |-- 1280_genomic_afterPurify.quast
    |-- 1351_genomic_afterPurify.quast
    |-- 1423_genomic_afterPurify.quast
    |-- 1613_genomic_afterPurify.quast
    |-- 1639_genomic_afterPurify.quast
    |-- 287_genomic_afterPurify.quast
    |-- 28901_genomic_afterPurify.quast
    |-- 4932_genomic_afterPurify.quast
    |-- 5207_genomic_afterPurify.quast
    `-- 562_genomic_afterPurify.quast
```
