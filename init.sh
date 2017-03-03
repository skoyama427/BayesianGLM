#!bin/sh

dir=./OUTPUT; [ ! -e $dir ] && mkdir -p $dir
dir=./DATA; [ ! -e $dir ] && mkdir -p $dir

wget https://github.com/linnarsson-lab/ipynb-lamanno2016/archive/master.zip
unzip master.zip
mv ipynb-lamanno2016-master/data/*.cef ./DATA
mv ipynb-lamanno2016-master/data/*.tsv ./DATA
rm -r ipynb-lamanno2016-master
