#! /usr/bin/env bash
LOG(){ echo -e "\e[38;5;40m`date`: $@ \e[39m";}

LOG "Stop SSH Host Key Checking"
sed -i 's/#.*StrictHostKeyChecking .*/StrictHostKeyChecking no/' /etc/ssh/ssh_config

LOG "Install EPEL Repo . . . "
yum install epel-release -y

LOG "Update System . . ."
yum update -y

LOG "Groupinstall Development Tools . . ."
yum groupinstall 'Development Tools' -y

LOG "Install python-pip python-devel expect. . ."
yum install python3 python3-pip expect tree -y

LOG "Update pip . . ."
pip3 install --upgrade pip

LOG "install libselinux-python . . ."
pip3 install selinux

LOG "Install virtualenv . . ."
pip3 install virtualenv

LOG "STOP AUTO-LOGOUT . . . AND Redirect known host file to null . . ."
grep '^TCPKeepAlive' /etc/ssh/sshd_config -q && sed -i 's/^TCPKeepAlive.*/TCPKeepAlive yes/g' /etc/ssh/sshd_config || sed -i '$a TCPKeepAlive yes' /etc/ssh/sshd_config
grep '^ClientAliveInterval' /etc/ssh/sshd_config -q && sed -i 's/^ClientAliveInterval.*/ClientAliveInterval 30/g' /etc/ssh/sshd_config || sed -i '$a ClientAliveInterval 30' /etc/ssh/sshd_config
grep '^ClientAliveCountMax' /etc/ssh/sshd_config -q && sed -i 's/^ClientAliveCountMax.*/ClientAliveCountMax 288/g' /etc/ssh/sshd_config || sed -i '$a ClientAliveCountMax 288' /etc/ssh/sshd_config
grep '^UserKnownHostsFile' /etc/ssh/ssh_config && sed -i 's/^UserKnownHostsFile.*/UserKnownHostsFile \/dev\/null/g' /etc/ssh/ssh_config || sed -i '$a UserKnownHostsFile \/dev\/null' /etc/ssh/ssh_config
systemctl restart sshd

LOG "set python reminder . . ."
cat>~/.pystartup.py<<EOF
import readline
import rlcompleter

if 'libedit' in readline.__doc__:
    readline.parse_and_bind("bind ^I rl_complete")
else:
    readline.parse_and_bind("tab: complete")
EOF
grep 'PYTHONSTARTUP' ~/.bashrc || (sed -i '$aexport PYTHONSTARTUP=$HOME/.pystartup.py' ~/.bashrc &&  source ~/.bashrc)


LOG 'set VIM . . . '
cat>~/.vimrc<<EOF
syntax on
set tabstop=4
set expandtab
EOF

# Install git 2.17 from StorageAccount saausdevrepo as minimum requirement of VSTS is 2.0
LOG "Install git 2.17 from Storage Account saausdevrepo . . ."
git --version && yum remove -y git || yum install -y https://github.com/siaomingjeng/rpms/raw/master/git-2.30.1-1.el7.x86_64.rpm

# Pre-requisites for Ansible PostgreSQL module
LOG " Install PostgreSQL10 client . . ."
yum install -y https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm
yum install -y postgresql10

LOG "Create and Activate Ansible Virtualenv and  Install ansible[azure]. . ."
virtualenv ansible-env
source ansible-env/bin/activate
if [ "A$1" == "Alatest" -o "A$1" == "A" ]
then
    LOG "Install latest ansible . . . "
    pip3 install ansible
else
   LOG "Install ansible==$1 . . . "
   pip3 install ansible==$1
fi

# Since version 2.10 of ansible, quite a few modules have been moved to external collections and are not part of the core of ansible anymore. You need to install those collections in your local ansible environment if you intend to use them.
LOG "Install Azure Modules . . ."
curl -O https://raw.githubusercontent.com/ansible-collections/azure/dev/requirements-azure.txt
pip install -r requirements-azure.txt
rm requirements-azure.txt
# ansible-galaxy collection install azure.azcollection # Not used temporarily

LOG " Ansible PostgreSQL dependencies . . ."
pip install psycopg2

LOG " Finished!!!"


