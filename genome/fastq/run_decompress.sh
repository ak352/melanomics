
job1()
{
    for k in patient_2_NS patient_2_PM patient_4_NS patient_4_PM
    do
	./decompress.sh $k
    done
}

job2()
{

    for k in patient_5_NS patient_5_PM patient_6_NS patient_6_PM
    do
	./decompress.sh $k
    done
}

job3()
{
    for k in patient_7_NS patient_7_PM patient_8_NS patient_8_PM NHEM
    do
        ./decompress.sh $k
    done
}

test_job()
{
    for k in patient_7_PM
    do
        ./decompress.sh $k
    done

}



#If Abhimanyu, uncomment line below
job1
#If Susanne, uncomment line below
#job2
#And once the others are done
#job3
#Test
#test_job


#Patients done
#patient_7_NS
