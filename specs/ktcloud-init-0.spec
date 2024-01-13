Name:      ktcloud-init
Version:   0
Release:   1%{?dist}
Summary:   KT Cloud init scripts for a Systemd service unit
BuildArch: noarch

License:   Apache-2.0
Source0:   %{name}-%{version}.tar.gz

Requires:  systemd NetworkManager bash curl shadow-utils

%description
ktcloud-init is a set of modified original init scripts from KT Cloud for
deployment in modern industry standard cloud base images. The package enables
the image to be usable on the KT Cloud service.

%prep
%setup -q

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/%{_libexecdir}
mkdir -p $RPM_BUILD_ROOT/%{_prefix}/lib/systemd/system
cp -a src/libexec/* $RPM_BUILD_ROOT/%{_libexecdir}
cp -a src/systemd/* $RPM_BUILD_ROOT/%{_prefix}/lib/systemd/system

%files
%{_libexecdir}
%{_prefix}/lib/systemd/system
