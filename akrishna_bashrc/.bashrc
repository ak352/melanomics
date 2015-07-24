# ~/.bashrc: executed by bash(1) for non-login shells.

export CLICOLOR=1
#export PS1="\[\e[24;1m\][\t]\e[0m \u@\h \[\e[34;1m\]\W\e[0m> "

# Uncomment if using white background
# export PS1="\[\e[24;1m\][\t]\[\e[0m\] \u@\h \[\e[34;1m\]\W\[\e[0m\]> " 
# Uncomment if using black background
 export PS1="\[\e[24;1m\][\t]\[\e[0m\] \u@\h \[\e[31;1m\]\W\[\e[0m\]> "  

#export PS1='[\t] \u@\h \W $ '
umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
 export LS_OPTIONS='--color=auto'
 eval `dircolors`
 alias ls='ls $LS_OPTIONS'
 alias ll='ls $LS_OPTIONS -l'
 alias la='ll -a'
 alias l='ls $LS_OPTIONS -lA'
#
# Some more alias to avoid making mistakes:
 alias rm='rm -i'
 alias cp='cp -i'
 alias mv='mv -i'

#bind "set bell-style visible"
set bell-style visible


# Uncomment the following line if using a white background screen
 LS_COLORS="rs=0:di=01;31:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:"

alias hpcstats="$HOME/hpc_stats.sh"
alias melanomics="cd /work/projects/melanomics/scripts/genome/"
alias tawk='awk -F"\t"'
alias nfawk='tawk "{print NF;}"'
alias inter='oarsub -Ilwalltime=12'

source ~/.modules
export EBHOME="$HOME/easybuild_home/hpcugent-easybuild-ecb981c"
export CFGS="$EBHOME/easybuild/easyconfigs"



PYTHONPATH="${PYTHONPATH}":/home/clusterusers/akrishna/scripts/python/
PYTHONPATH="${PYTHONPATH}":/home/clusterusers/akrishna/scripts/python/class/
PYTHONPATH="${PYTHONPATH}":/work/projects/igepilot/tools/python-setuptools/install/
PYTHONPATH="${PYTHONPATH}":/work/projects/melanomics/tools/networkx/networkx/release//lib/python3.2/site-packages

MODULEPATH="${MODULEPATH}"://work/projects/isbsequencing/tools/privatemodules/
MODULEPATH="${MODULEPATH}"://work/projects/melanomics/tools/privatemodules/
MODULEPATH="${MODULEPATH}":/work/projects/isbsequencing/tools/hugeseq/modulefiles/
export MODULEPATH

PATH="${PATH}":/work/projects/melanomics/tools/samtools/samtools-0.1.19/
export PATH

# To get rid of perl warnings
export LC_ALL=en_US.UTF-8

export MYTMP=/tmp/akrishna/

alias luhmes="cd /work/projects/isbsequencing/luhmes_cell_line/users/akrishna/"
alias cindex="~/cindex"
alias fields="~/fields"
alias oarres="~/oarres.sh"
alias showcol="column -ts $'\t'"
alias emacs="${HOME}/.resif/v1.1-20150414/software/tools/emacs/24.5/bin/emacs"


command -v module >/dev/null 2>&1 && module use $RESIF_ROOTINSTALL/core/modules/all
command -v module >/dev/null 2>&1 && module use $RESIF_ROOTINSTALL/lcsb/modules/all
