python pipeline.py --dindel -i melanomics.in -r /work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa -v --temp /scratch/users/akrishna/melanomics/
python pipeline.py --dindel2 -i melanomics.in -r /work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa -v --temp /scratch/users/akrishna/melanomics/
python pipeline.py --dindel3 -i bamfiles/melanomics.in -r /work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa --dindel3-files-per-node 100 -v --temp /scratch/users/akrishna/melanomics/