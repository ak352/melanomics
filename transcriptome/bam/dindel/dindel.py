import os
import oar

def dindel(bamfile, reference, tools_dir, option):
    """Strip location so that output is in the current directory"""
    path = ""
    if option.temp:
        if os.path.isfile(option.temp):
            os.mkdir(option.temp)
        path = option.temp + "/"
    bamfile_without_path  = str(bamfile).split("/")[-1]

    list_cmd = []
    """Dindel stage 1"""
    list_cmd.append(tools_dir + '/dindel/binaries/dindel --analysis getCIGARindels --ref ' + reference + ' --outputFile ' + path+bamfile_without_path + '.dindel_output --bamFile '+bamfile)
    oarsub_command = oar.oarsub_cmd(list_cmd, 72, 2)
    return oarsub_command

def dindel_stage_2(bamfile, reference, tools_dir, option):
    """Strip location so that output is in the current directory"""
    path = ""
    if option.temp:
        if os.path.isfile(option.temp):
            os.mkdir(option.temp)
        path = option.temp + "/"
    bamfile_without_path  = str(bamfile).split("/")[-1]
    list_cmd = []
    """Dindel stage 2"""
    list_cmd.append('python ' + tools_dir +'/dindel/dindel-1.01-python/makeWindows.py --inputVarFile '
                    + path+bamfile_without_path + '.dindel_output.variants.txt '+
                    '--windowFilePrefix ' + path + 'realign_windows/'+bamfile_without_path+'.realign_windows --numWindowsPerFile 1000')
    list_cmd.append('ls -1 ' + path + 'realign_windows/'+bamfile_without_path+'.realign_windows* | wc -l > '+ path+bamfile_without_path + '.num_files')
    oarsub_command = oar.oarsub_cmd(list_cmd, 72,2)
    return oarsub_command

def dindel_stage_3(bamfile, reference, tools_dir, number_of_files_per_node, option):
    """Strip location so that output is in the current directory"""
    path = ""
    if option.temp:
        if os.path.isfile(option.temp):
            os.mkdir(option.temp)
        path = option.temp + "/"
    bamfile_without_path  = str(bamfile).split("/")[-1]
    
    """Dindel stage 3: most intensive stage computationally"""
    """Total number of files created by makeWindows.py"""
    max_num = int(GetStringFomFile(path+bamfile_without_path + '.num_files'))
    assert max_num>0, ("Total number of files created by makeWindows.py = ", max_num, " bam filename = ", path+bamfile_without_path +  + '.num_files')
    """Realign to haplotypes from each file on a separate node in parallel"""
    oarsub_command = ""
    for interval in range(1, max_num+1, number_of_files_per_node):
        list_cmd = []
        for num in range(interval, interval+number_of_files_per_node):
            """Break the loop if file number exceeds total number of files"""
            if num > max_num:
                break
            varFile = path + 'realign_windows/' + bamfile_without_path + '.realign_windows.'+str(num)+'.txt'
            libFile = path + bamfile_without_path+'.dindel_output.libraries.txt'
            outputFile = path + 'realign_windows/'+bamfile_without_path+'.dindel_stage2_output_windows.'+str(num)

            list_cmd.append(tools_dir + '/dindel/binaries/dindel --analysis indels --doPooled --bamFile '+bamfile
                +' --ref '+ reference
                +' --varFile '+ varFile
                +' --libFile '+ libFile
                +' --outputFile '+ outputFile)

        """Each oarsub command includes number_of_files_per_node files"""
        oarsub_command = oarsub_command + oar.oarsub_cmd(list_cmd, 72,2) + ";"

    if option.verbose:
        print "oarsub command = ", oarsub_command

    return oarsub_command


def dindel_stage_4(bamfile, reference, tools_dir, option):
    """Strip location so that output is in the current directory"""
    path = ""
    if option.temp:
        if os.path.isfile(option.temp):
            os.mkdir(option.temp)
        path = option.temp + "/"
    bamfile_without_path  = path + str(bamfile).split("/")[-1]
    list_cmd = []

    """Dindel stage 4"""
    list_cmd.append('rm -rf '+bamfile_without_path+'.dindel_stage2_outputfiles.txt')
    max_num = int(GetStringFomFile(path+bamfile_without_path + '.num_files'))
    for num in range(1, max_num+1):
        list_cmd.append('echo "realign_windows/' + bamfile_without_path +
                        '.dindel_stage2_output_windows.'+str(num)+'.glf.txt" >> '+bamfile_without_path+'.dindel_stage2_outputfiles.txt')
    list_cmd.append('python ' + tools_dir +'/dindel/dindel-1.01-python/mergeOutputDiploid.py '
                    + '--inputFiles '+bamfile_without_path + '.dindel_stage2_outputfiles.txt '
                    + '--outputFile '+bamfile_without_path+'.dindel.vcf '
                    + '-r ' + reference + ' '
                    + '-f 0')

    if option.verbose:
        print list_cmd

    oarsub_command = oar.oarsub_cmd(list_cmd, 72, 2)
    return oarsub_command

def prepare_dindel_directories(option):
    if not option.temp:
        print "No option specified for temporary directory, using current directory..."
    else:
        print "Temporary directory: " + option.temp
    os.system("rm -rf " + option.temp + "realign_windows; mkdir "+ option.temp + "realign_windows")


def GetStringFomFile(filename):
    string = ""
    for line in open(filename):
        string = string + line.rstrip()
    assert string.isdigit(), (filename, " does not contain only a number")
    return string
