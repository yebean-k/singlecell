#!/bin/bash

metadata=("GIMATS_meta_sed.txt" "ALL_meta_sed.txt")
loc=/data/yebin/singlecell/cellphonedb/

#prepare cellphonedb
conda create -n cpdb python=3.7
source activate cpdb
pip install cellphonedb

#run cellphonedb
for i in {0..1}; do
        for d in ${metadata[i]}; do
                d_name=$(echo $d | awk -F "_" '{print $1}')
                echo $d_name
		
		cellphonedb method statistical_analysis $loc$d $loc$d_name'_counts.txt' --counts-data=gene_name --threads=20 --project-name $d_name
		
		mv $loc'out'/$d_name $loc

		cellphonedb plot heatmap_plot $loc$d --pvalues-path $loc$d_name/pvalues.txt --output-path $loc$d_name

		for name in `ls | grep 'columns' | cut -d "_" -f 1`; do 
			
			cellphonedb plot dot_plot --means-path $loc$d_name/means.txt --pvalues-path $loc$d_name/pvalues.txt --columns $name'_columns.txt' --output-path $loc$d_name --output-name $name'_dot_plot.pdf'
		done
	done
done
