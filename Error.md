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
/lib64/libstdc++.so.6: version `GLIBCXX_3.4.22' not found (required by usr/software/wengan/wengan-v0.2-bin-Linux/bin/minia)
/lib64/libstdc++.so.6: version `CXXABI_1.3.11' not found (required by usr/software/wengan/wengan-v0.2-bin-Linux/bin/minia)
/lib64/libstdc++.so.6: version `GLIBCXX_3.4.21' not found (required by usr/software/wengan/wengan-v0.2-bin-Linux/bin/minia)
/lib64/libstdc++.so.6: version `CXXABI_1.3.8' not found (required by usr/software/wengan/wengan-v0.2-bin-Linux/bin/minia)
/lib64/libstdc++.so.6: version `GLIBCXX_3.4.20' not found (required by usr/software/wengan/wengan-v0.2-bin-Linux/bin/minia)
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
