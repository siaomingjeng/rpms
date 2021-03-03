CREATE GIT RPM FOR CENTOS 7  (Raymond ZHENG on 12 APR 2018, updated on 03 MAR 2020)

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
Prefix:         /usr/local

BuildRequires:  gcc,make
Requires:       perl-Git,perl-Error,perl-TermReadKey

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
/usr/local/bin/git*
/usr/local/libexec/git*
/usr/local/share/git*
/usr/local/share/locale/el/LC_MESSAGES/git.mo
/usr/local/share/locale/pl/LC_MESSAGES/git.mo
/usr/local/share/locale/tr/LC_MESSAGES/git.mo
/usr/local/share/locale/bg/LC_MESSAGES/git.mo
/usr/local/share/locale/ca/LC_MESSAGES/git.mo
/usr/local/share/locale/de/LC_MESSAGES/git.mo
/usr/local/share/locale/es/LC_MESSAGES/git.mo
/usr/local/share/locale/fr/LC_MESSAGES/git.mo
/usr/local/share/locale/is/LC_MESSAGES/git.mo
/usr/local/share/locale/it/LC_MESSAGES/git.mo
/usr/local/share/locale/ko/LC_MESSAGES/git.mo
/usr/local/share/locale/pt_PT/LC_MESSAGES/git.mo
/usr/local/share/locale/ru/LC_MESSAGES/git.mo
/usr/local/share/locale/sv/LC_MESSAGES/git.mo
/usr/local/share/locale/vi/LC_MESSAGES/git.mo
/usr/local/share/locale/zh_CN/LC_MESSAGES/git.mo
/usr/local/share/locale/zh_TW/LC_MESSAGES/git.mo
/usr/local/share/perl5/FromCPAN/Error.pm
/usr/local/share/perl5/FromCPAN/Mail/Address.pm
/usr/local/share/perl5/Git*

%doc

%changelog
EOF
```
Note: adjust the files above according to "RPM build errors: Installed (but unpackaged) file(s) found".
# Download Source Code:
```wget -O rpmbuild/SOURCES/git-2.30.1.tar.gz https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.30.1.tar.gz```

# RPM's
```rpmbuild -bb rpmbuild/SPECS/git.spec```
RPM will be generated in rpmbuild/RPMS
