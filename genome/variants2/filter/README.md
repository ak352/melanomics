# Variant Annotation for Quality Control
1. This module takes a variant file in the Complete Genomics testvariants format and the corresponding VCF file annotated with coverage and annotates them with 

- coverage
- genotype quality
- distance to nearest indel
- hompolymer
- distance to nearest homopolymer region
- simple repeats
- segmental duplications
- RepeatMasker
- microsatellites
- self-chained regions

2. To annotate the variants, the launcher script is script.sh

3. At the end of script.sh, there are 
- functions to prepare the annotation databases (run-once)
- functions to annotate (run every time a variant file needs to be annotated)

4. First comment out the run-once functions and run the script.sh - 
```
# Preparing files for annotation
homopolymer_one                                                                                                                     
simple_repeat_once                                                                                                                   
segdup_once                                                                                                                          
rmsk_once                                                                                                                            
microsatellite_once                                                                                                                  
scr_once                                                                                                                             
```

5. Then comment them back in and comment out the annotation functions - 

```
homopolymer                                                                                                                          
simple_repeat                                                                                                                        
segdup                                                                                                                               
rmsk                                                                                                                                 
microsatellite                                                                                                                       
scr                                                                                                                                  
distance_hp 
paste_all
```

6. The status messages in standard output should show the location of the intermediate and output files generated.



