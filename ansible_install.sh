#! /usr/bin/env bash


echo -e '\033[35;5m Stop SSH Host Key Checking . . . \033[0m'
sudo sed -i 's/#.*StrictHostKeyChecking .*/StrictHostKeyChecking no/' /etc/ssh/ssh_config

echo -e '\033[35;5m Install EPEL Repo . . . \033[0m'
sudo yum install epel-release -y

echo -e '\033[35;5m Update System . . . \033[0m'
sudo yum update -y

echo -e '\033[35;5m Install python-pip . . . \033[0m'
sudo yum install python-pip -y

echo -e '\033[35;5m Update pip . . . \033[0m'
sudo pip install --upgrade pip

echo -e '\033[35;5m Groupinstall Development Tools . . . \033[0m'
sudo yum groupinstall 'Development Tools' -y

echo -e '\033[35;5m Install python-devel . . . \033[0m'
sudo yum install python-devel -y

echo '\033[35;5m Install ansible[azure] . . . \033[0m'
if [ "A$1" == "Alatest" -o "A$1" == "A" ]
then
    echo "Install latest ansible[azure] . . . "
    sudo pip install ansible[azure]
else
   echo "Install ansible[azure]==$1 . . . "
   sudo pip install ansible[azure]==$1
fi

echo '\033[35;5m Install virtualenv . . . \033[0m'
sudo pip install virtualenv

echo '\033[35;5m set python reminder . . . \033[0m'
cat>~/.pystartup.py<<EOF
import readline
import rlcompleter

if 'libedit' in readline.__doc__:
    readline.parse_and_bind("bind ^I rl_complete")
else:
    readline.parse_and_bind("tab: complete")
EOF
PYTHONSTARTUP=$(cat ~/.bashrc|grep 'PYTHONSTARTUP')
if [ "A$PYTHONSTARTUP" = "A" ]
then
    sudo sed -i '$aexport PYTHONSTARTUP=$HOME/.pystartup.py' ~/.bashrc
    source ~/.bashrc
fi

echo 'set VIM . . . '
cat>~/.vimrc<<EOF
syntax on
set tabstop=4
set expandtab
EOF

echo '\033[35;5m STOP AUTO-LOGOUT . . . \033[0m'
if [ "$(sudo cat /etc/ssh/sshd_config |grep '^TCPKeepAlive')x" == x ]
then
    sudo sed -i '$a TCPKeepAlive yes' /etc/ssh/sshd_config
else
    sudo sed -i 's/^TCPKeepAlive.*/TCPKeepAlive yes/g' /etc/ssh/sshd_config
fi

if [ "$(sudo cat /etc/ssh/sshd_config |grep '^ClientAliveInterval')x" == x ]
then
    sudo sed -i '$a ClientAliveInterval 30' /etc/ssh/sshd_config
else
    sudo sed -i 's/^ClientAliveInterval.*/ClientAliveInterval 30/g' /etc/ssh/sshd_config
fi

if [ "$(sudo cat /etc/ssh/sshd_config |grep '^ClientAliveCountMax')x" == x ]
then
    sudo sed -i '$a ClientAliveCountMax 288' /etc/ssh/sshd_config
else
    sudo sed -i 's/^ClientAliveCountMax.*/ClientAliveCountMax 288/g' /etc/ssh/sshd_config
fi

# Redirect known host file to null.
if [ "$(sudo cat /etc/ssh/ssh_config |grep '^UserKnownHostsFile')x" == x ]
then
    sudo sed -i '$a UserKnownHostsFile \/dev\/null' /etc/ssh/ssh_config
else
    sudo sed -i 's/^UserKnownHostsFile.*/UserKnownHostsFile \/dev\/null/g' /etc/ssh/ssh_config
fi
sudo systemctl restart sshd

# Install git 2.17 from StorageAccount saausdevrepo as minimum requirement of VSTS is 2.0
echo '\033[35;5m Install git 2.17 from Storage Account saausdevrepo . . . \033[0m'
sudo yum remove -y git
sudo yum install -y https://github.com/siaomingjeng/rpms/raw/master/git-2.20.1-1.el7.x86_64.rpm

# Pre-requisites for Ansible PostgreSQL module
echo -e '\033[35;5m  Ansible PostgreSQL dependencies . . . \033[0m'
sudo pip install psycopg2
echo -e '\033[35;5m  Install PostgreSQL10 client . . . \033[0m'
sudo yum install -y https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm
sudo yum install -y postgresql10


echo -e '\033[35;5m  Finished!!! \033[0m'



