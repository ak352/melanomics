# ~/.bash_profile: executed by bash(1) for login shells.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/login.defs
#umask 022

# the rest of this file is commented out.

# include .bashrc if it exists

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# set PATH so it includes user's private bin if it exists
if [ -d ~/bin ] ; then
    PATH=~/bin:"${PATH}"
fi

# Add Java links
export JAVA_HOME=/usr/
#export CLASSPATH=$JAVA_HOME/lib

PATH="${PATH}":$JAVA_HOME/bin
export PATH

# do the same with MANPATH
if [ -d ~/man ]; then
    MANPATH=~/man:"${MANPATH}"
    export MANPATH
fi



#set alias for the new cmake
alias cmk=/mnt/projects/isbsequencing/tools/cmake-2.8.8/bin/cmake
alias mine="oarstat | grep akrishna"
alias mined="oarstat --user akrishna -f"
alias susy="oarstat --user sreinsbach"
alias susyd="oarstat --user sreinsbach -f"

# set PATH sp that it includes Genomics tools 
PATH="${PATH}":/home/clusterusers/akrishna/tools/cgatools-1.5.0.31-linux_binary-x86_64/bin
#PATH="${PATH}":/mnt/projects/isbsequencing/tools/cgatools-1.5.0.31-linux_binary-x86_64/perl/testvariants2VCF-v2
#PATH="${PATH}":/mnt/projects/isbsequencing/tools/samtools/bcftools
#PATH="${PATH}":/mnt/projects/isbsequencing/tools/tabix-0.2.6/
#PATH="${PATH}":/mnt/projects/isbsequencing/tools/boost-jam/boost-jam-3.1.18/bin.linuxx86_64/
PATH="${PATH}":/home/clusterusers/akrishna/CV/OpenCV-2.3.1/release/bin


# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


