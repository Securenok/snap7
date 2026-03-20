# Converting from Debian to RPM Build System

This document explains the conversion from the Debian package build script (`build_snap7_debs.sh`) to the RPM build system using `rpmbuild`.

## Files Created

1. **snap7-securenok.spec** - The RPM spec file (equivalent to Debian's control file + scripts)
2. **build_snap7_rpms.sh** - A build helper script to automate the RPM build process

## Quick Start

### Prerequisites

Install RPM build tools on a Red Hat/CentOS/Fedora system:

```bash
sudo dnf install rpm-build gcc gcc-c++ make
# or on older systems:
sudo yum install rpm-build gcc gcc-c++ make
```

### Building the RPM Package

```bash
# From the snap7-main directory
chmod +x build_snap7_rpms.sh
./build_snap7_rpms.sh
```

The script will:
1. Create a temporary build directory (`/tmp/snap7-rpmbuild`)
2. Bundle the source code into a tarball
3. Run `rpmbuild` to create both binary and source RPMs
4. Display the location of the built packages

### Manual Build with rpmbuild

If you prefer to build manually:

```bash
# Set up the build directory structure
mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

# Copy the spec file
cp snap7-securenok.spec ~/rpmbuild/SPECS/

# Create the source tarball
tar czf ~/rpmbuild/SOURCES/snap7-full-1.4.2.tar.gz snap7-full-1.4.2/

# Build the RPM
rpmbuild -ba ~/rpmbuild/SPECS/snap7-securenok.spec
```

## Installing the RPM

After building, install the package:

```bash
# Install the library package
sudo rpm -ivh /tmp/snap7-rpmbuild/RPMS/x86_64/libsnap7-securenok-1.4.2-1.securenok.fc*.x86_64.rpm

# Install development headers (optional)
sudo rpm -ivh /tmp/snap7-rpmbuild/RPMS/x86_64/libsnap7-securenok-devel-1.4.2-1.securenok.fc*.x86_64.rpm
```

To upgrade an existing installation:

```bash
sudo rpm -Uvh /tmp/snap7-rpmbuild/RPMS/x86_64/libsnap7-securenok-*.rpm
```

## Differences Between Debian and RPM Build

### Directory Structure

| Debian | RPM |
|--------|-----|
| `/tmp/libsnap7-securenok-${DEB_ARCH}/DEBIAN/` | Spec file with %pre, %post, %postun sections |
| `/tmp/libsnap7-securenok-${DEB_ARCH}/usr/lib/` | `%{_libdir}` macro (usually `/usr/lib64` or `/usr/lib`) |
| `/tmp/libsnap7-securenok-${DEB_ARCH}/usr/include/` | `%{_includedir}` macro (usually `/usr/include`) |

### Build Process

**Debian Approach (Original Script):**
- Manual directory creation
- Manual file copying
- Uses `dpkg-deb --build` to create the package
- Builds both i386 and amd64 in a loop

**RPM Approach (New):**
- Declarative spec file defines all operations
- Automated through `rpmbuild`
- Architecture handled through `%ifarch` directives
- Single spec file, multiple RPMs via rpmbuild

### Scripts

**Debian:**
- `preinst` - runs before package installation
- `postinst` - runs after package installation

**RPM:**
- `%pre` - runs before package installation
- `%post` - runs after package installation
- `%postun` - runs after package removal

## Key Features of the RPM Recipe

1. **Dual Packages:**
   - `libsnap7-securenok` - runtime library
   - `libsnap7-securenok-devel` - development headers

2. **Automatic Architecture Detection:**
   - The spec file uses `%ifarch` to detect the build architecture
   - Automatically selects the correct binary (i386-linux or x86_64-linux)

3. **Pre/Post Scripts:**
   - `%pre` - removes existing library before upgrade
   - `%post` - updates library cache with `ldconfig`
   - `%postun` - cleans up library cache on uninstall

4. **License Files:**
   - Includes GPL and LGPL license files

## Customization

Edit `snap7-securenok.spec` to customize:

- **Version/Release**: Change the `Version` and `Release` fields
- **Dependencies**: Modify `Requires` field
- **Source Path**: Change the `Source0` URL
- **License**: Update the `License` field if needed
- **Changelog**: Add new entries to `%changelog`

## Cross-Compilation

To build for a different architecture, use the `--target` option:

```bash
# Build for i686 (32-bit)
rpmbuild --target i686 -ba ~/rpmbuild/SPECS/snap7-securenok.spec

# Build for x86_64 (64-bit)
rpmbuild --target x86_64 -ba ~/rpmbuild/SPECS/snap7-securenok.spec
```

## Troubleshooting

### Missing build dependencies
```bash
# Install required tools
sudo dnf install rpm-build gcc gcc-c++ make glibc-devel
```

### rpmbuild: command not found
```bash
sudo dnf install rpm-build
```

### Source files not found during build
Ensure the tarball exists and contains the correct directory structure:
```bash
tar tzf ~/rpmbuild/SOURCES/snap7-full-1.4.2.tar.gz | head -20
```

Should show:
```
snap7-full-1.4.2/
snap7-full-1.4.2/build/
snap7-full-1.4.2/release/
...
```

## References

- [RPM Packaging Guide](https://rpm-software-management.github.io/rpm/)
- [Create packages with rpmbuild](https://rpm-software-management.github.io/rpm/index.html)
- [Fedora Packaging Guidelines](https://docs.fedoraproject.org/en-US/packaging-guidelines/)
