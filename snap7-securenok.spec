%define debug_package %{nil}

Name:           libsnap7-securenok
Version:        1.4.2
Release:        rhel10
Summary:        Modified Snap7 library from Securenok fork
License:        GPL-2.0 and LGPL-3.0

URL:            https://github.com/SecureNOK/snap7
Source0:        snap7-full-1.4.2.tar.gz

BuildRequires:  gcc
BuildRequires:  gcc-c++
BuildRequires:  make

Requires:       glibc

%description
A custom version of Snap7 installed as libsnap7-securenok.
This is a modified Snap7 library provided by Securenok.

%package devel
Summary:        Development files for libsnap7-securenok
Requires:       %{name}%{?_isa} = %{version}-%{release}

%description devel
Development headers and files for libsnap7-securenok library.

%prep
%setup -q -n snap7-full-1.4.2

%build
# The snap7 library should already be pre-built
# If you need to rebuild from source, add build commands here
# For now, we assume binaries are included in the source tarball

%install
rm -rf %{buildroot}

# Determine architecture-specific binary path
%ifarch i386
    ARCH_DIR="i386-linux"
%else
%ifarch x86_64
    ARCH_DIR="x86_64-linux"
%else
    ARCH_DIR="x86_64-linux"
%endif
%endif

# Create directory structure
mkdir -p %{buildroot}%{_libdir}
mkdir -p %{buildroot}%{_includedir}/snap7

# Install library
install -D -m 0755 build/bin/${ARCH_DIR}/libsnap7.so \
    %{buildroot}%{_libdir}/libsnap7-securenok.so

# Install headers
install -d -m 0755 %{buildroot}%{_includedir}/snap7
install -m 0644 release/*.h %{buildroot}%{_includedir}/snap7/ 2>/dev/null || true

%pre
# Remove existing library if present
if [ -f "%{_libdir}/libsnap7-securenok.so" ]; then
    echo "Removing existing %{_libdir}/libsnap7-securenok.so before upgrade"
    rm -f "%{_libdir}/libsnap7-securenok.so"
fi
exit 0

%post
# Fix library permissions
chmod 0755 %{_libdir}/libsnap7-securenok.so

# Update library cache
/sbin/ldconfig

%postun
# Update library cache after uninstall
/sbin/ldconfig

%files
%license gpl.txt lgpl-3.0.txt
%doc README.txt
%{_libdir}/libsnap7-securenok.so

%files devel
%{_includedir}/snap7/

#%changelog
#* Thu Mar 20 2026 SNOK Developer <developer@securenok.com> - 1.4.2-1.securenok
#- Initial RPM package creation from Securenok snap7 fork

%clean
rm -rf %{buildroot}
