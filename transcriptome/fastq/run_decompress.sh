for k in patient_2_NS patient_2_PM patient_4_NS patient_4_PM patient_5_NS patient_5_PM patient_6_NS patient_6_PM patient_7_NS patient_7_PM patient_8_NS patient_8_PM NHEM
do
    oarsub -lwalltime=12 "./decompress.sh $k"
    
done
