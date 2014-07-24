
def oarsub_cmd(list_of_commands, walltime, number_of_cores):
    assert len(list_of_commands) > 0

    cmd = 'oarsub -lcore=' + str(number_of_cores) + ',walltime='+str(walltime) + ' "'
    for command in list_of_commands:
        cmd = cmd + command + ';'
    cmd = cmd + '"'
    return cmd
