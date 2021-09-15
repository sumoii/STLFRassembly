# MetaSTHD Assembly Pineline 

## Description:
Hybrid de novo assembly process of metagenomic STLF and TGS data based on Wengan  

The purpose of the pipline is that:  

The co-barcoding information of stLFR and the short reads are accurate ,which combine with the long reads advantages of the three generations of data to improve the de novo assembly effect of the metagenome.  

![25c6f7b7ce53908576dc45e26c5db5b](https://user-images.githubusercontent.com/79637824/133355070-8fb3662c-aa2d-40d3-9980-e16eda14f58c.png)



### The software are required:
1. Python3 (version >2.7) and gcc (version >7.2)  
2. metaWRAP  
3. quast  
4. perl  
5. WENGAN and CLOUDESPADES
6. longranger4stLFR      

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

Hybrid assembly with Wengan
-----------------------------------  
There have some necessary shellfile need to download  
Shellfile : https://github.com/sumoii/WENGANassemble.git
```
bin
|-- afterPurify_quast.sh
|-- createassemblyfile.sh
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

## Running quicking  
There have a run.sh in the pipeline ,if sh run.sh -1 -2 ... the all step are run at the moment

```
$ sh run.sh
        -l   The longread path
        -1   The shortreads1 path
        -2   The shortreads2 path
        -f   The first pirfix [default: STLFR_CLOUDSPADES ]
        -s   The other pirfix [default: WTDBG ]
        -t   The threads number
        -m   The model of Wengan
        -g   The memory of set [GB]
        -x   The longreads format [default : ont]
        -w   The whitelist path
        -L   The longranger4stLFR/longranger path
        -M   The methed of you choose  [Quast or Binning]
                Quast The quast way
                        require the follow options
                        -r   The reference path
                        -q   The quast path
                Binning The binning way
                        require the follow options
                        -b   The binning path (MeatWRAP)
        -A   Choose of all methed (binning and quast)
```  

## or Step by Step  

### Data preprocessing

```
$ source Step.1.0.getsource.sh \
-l usr/database/Zymo-GridION-EVEN-BB-SN-PCR-R10HC-flipflop.fq.gz  \
-1 usr/database/V300045526B_L01_read_1.fq.gz  \
-2 usr/database/V300045526B_L01_read_2.fq.gz
```  
```
$ sh Step.1.1.splitbarcode.sh -d Dataprepare -1 $shortreads1 -2 $shortreads2 -t $atools
$ sh Step.1.2.getcleandata.sh -t  $atools  -d Dataprepare
```
#### Step.1.3 STLFR > 10X
```
$ sh Step.1.3.stlfrto10x.sh
Usage:

         Preparing for  short assembly
         STLFR to 10X

Option:
        -a The tools path
        -1 The split_reads.1.fq.gz.clean.gz path
        -2 The split_reads.1.fq.gz.clean.gz path
        -t The threads numbers [default: 40]
        -w The whitelist path
        -l The longranger path
        -f filter_num [default: 2]
        -m mapratio_num [default: 8]
        -M The memory number GB [default: 300]  
        
$ sh Step.1.3.stlfrto10x.sh -a $atools -1 Dataprepare/split_reads.1.fq.gz.clean.gz  -2 Dataprepare/split_reads.1.fq.gz.clean.gz \
-w usr/database/whitelist \
-l usr/software/longranger4stLFR/longranger \
-f 2 -m 8 -M 300 -t 40
```

### Assmeble 
#### CLOUDSPADES AND WTDBG  
```
$ name1="STLFR_CLOUDSPADES"
$ name2="WTDBG"
$ model="A"
```
```
$ sh Step.2.1.stlfrcloudspades.sh -f STLFR10X/longranger/out/barcoded.fastq.gz -o ${name1}_contigs -t 8 -m 250
$ sh Step.2.2.ontwtdbg.sh -l $longreads -w usr/software/wtdbg -t 40 -x ont 
```
#### WENGAN
```
$ sh Step.3.1.wenganaseembly.sh -l ${name2}_contigs/WTDBG.fa \
-s ${name1}_contigs/cloudspades_out/contigs.fasta -m ${model} \
-1 Dataprepare/split_reads.1.fq.gz.clean.gz \
-2 Dataprepare/split_reads.1.fq.gz.clean.gz \
-f ${name1} -d ${name2} -t 40 -g 3000 -x ontraw
```
## Reference quast
### Quast
```
$ sh Step.4.1.1.prequast.sh 
Description:
        Prepare for quast
Option:
        -r The path of reference genomic folder
        -1 <The first name of your contigs prefix>
        -2 <The other name of your contigs prefix>      
        -m The model you choose  
        
$ sh Step.4.1.1.prequast.sh -r usr/database/mock10_kraken2-fa -1 ${name1} -2 ${name2} -m ${model}
```
```
$ sh Step.4.1.2.quast.sh
Description:
        Quast of assembled genomic
        
Option:
        -f The path of abssebly file
        -q The path of quast.py  
     
$ cd ${name1}_${name2}_${model}_quast
$ sh Step.4.1.2.quast.sh \
-f ../${name1}_${name2}_${model}_assemble/${name1}_${name2}.SPolished.asm.wengan.fasta \
-q usr/software/quast/quast.py
$ cd ..
```
### Purify
```
$ sh Step.4.1.3.purify.sh
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
$ sh Step.4.1.3.purify.sh -p $atools/contig_purify.py \
-r ${name1}_${name2}_${model}_assemble/${name1}_${name2}.SPolished.asm.wengan.fasta \
-1 ${name1} -2 ${name2} -m ${model}
```
### Quast after Purify
```
$ sh Step.4.1.4.afterpurifyquast.sh
Usage:
        Quast after Purify
Option:
        -1 <The first name of your contigs prefix>
        -2 <The other name of your contigs prefix>
        -m <The model of Wengan that you choose>
        -p <The path of quast>
 
$ sh Step.4.1.4.afterpurifyquast.sh -1 ${name1} -2 ${name2} -m ${model} -p usr/software/quast/quast.py
```  

## Binning  
```
$ sh Step.4.2.1.binning.sh -1 Dataprepare/split_reads.1.fq.gz.clean.gz -2 Dataprepare/split_reads.2.fq.gz.clean.gz \
-o ${name1}_${name2}_${model}_binning \
-M usr/software/metaWRAP \
-c 50 -x 10 -t 40 -l 1000
```

## Result
```
$ tree -L 1
.
|-- Dataprepare
|-- WTDBG_contigs
|-- STLFR_CLOUDSPADES_contigs
|-- STLFR_CLOUDSPADES_WTDBG_A_assemble
|-- STLFR_CLOUDSPADES_WTDBG_A_Purify
|-- STLFR_CLOUDSPADES_WTDBG_A_quast
|-- STLFR_CLOUDSPADES_WTDBG_A_quast_afterPurify
`-- STLFR_CLOUDSPADES_WTDBG_A_binning
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
|-- STLFR_CLOUDSPADES_WTDBG_A_quast_afterPurify
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
