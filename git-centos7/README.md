CREATE GIT RPM FOR CENTOS 7  (Dr. Raymond ZHENG on 12 APR 2018, updated on 03 MAR 2021)

# Source Packages:
15DEC2018:   https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.20.1.tar.gz
08FEB2021:   https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.30.1.tar.gz
All version: https://mirrors.edge.kernel.org/pub/software/scm/git/

# Environment Prepare(root):
```
yum -y install epel-release
yum -y groupinstall "Development Tools"
yum -y install gettext-devel openssl-devel perl-CPAN perl-devel zlib-devel curl-devel expat-devel gettext-devel perl-ExtUtils-MakeMaker
yum install -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel rpm-build rpmdevtools
```
# Verify (general user):
```
rpmdev-setuptree
rpmbuild --showrc | grep topdir
```
# SPEC:
```
cat>rpmbuild/SPECS/git.spec<<EOF
Name:           git
Version:        2.30.1
Release:        1%{?dist}
Summary:        Git created for CentOS 7 by Dr. Raymond.

Group:          Development/Tools
License:        GPL
URL:            https://github.com/siaomingjeng
Source0:        https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.30.1.tar.gz
Prefix:         /usr

BuildRequires:  gcc,make
Requires:        apr apr-util neon pakchois perl-CGI perl-Compress-Raw-Bzip2 perl-Compress-Raw-Zlib  perl-DBI perl-Data-Dumper perl-Digest perl-Digest-MD5 perl-FCGI perl-IO-Compress perl-Net-Daemon perl-PlRPC perl-YAML subversion subversion-libs subversion-perl

%description
This git is built from offical source code 2.30.1 for CentOS 7.

%prep
%setup -q


%build
echo dist=%{?dist}: _topdir=%{_topdir}: _mandir=%{_mandir}: buildroot=%{buildroot}
make configure

%configure
./configure --prefix=%{prefix} --mandir=%{_mandir} --sysconfdir=/etc
make %{?_smp_mflags}

%install
make install DESTDIR=%{buildroot}
echo 'Install Finished!**********************************'

%files
/usr/bin/*
/usr/libexec/*
/usr/share/*

%doc

%changelog
EOF
```
Note: adjust the "%files" above according to "RPM build errors: Installed (but unpackaged) file(s) found".
Remove "Requires:". The dependencies of "perl-Git,perl-Error,perl-TermReadKey" from GIT causes installation issues.
# Download Source Code:
```wget -O rpmbuild/SOURCES/git-2.30.1.tar.gz https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.30.1.tar.gz```

# RPM's
```rpmbuild -bb rpmbuild/SPECS/git.spec```

RPM will be generated in rpmbuild/RPMS
