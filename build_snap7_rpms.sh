#!/bin/bash
set -e

# Build script for creating RPM packages using rpmbuild
# This replaces the Debian build script (build_snap7_debs.sh)

SPEC_FILE="snap7-securenok.spec"
SOURCE_DIR="${SOURCE_DIR:-.}"
BUILD_DIR="${BUILD_DIR:-/tmp/snap7-rpmbuild}"
SNAP7_VERSION="1.4.2"

# Check if spec file exists
if [ ! -f "$SPEC_FILE" ]; then
    echo "Error: $SPEC_FILE not found!"
    exit 1
fi

# Create RPM build directory structure
mkdir -p "$BUILD_DIR"/{BUILD,RPMS,SOURCES,SPECS,SRPMS,BUILDROOT}

echo "Building RPM packages..."
echo "Build directory: $BUILD_DIR"

# Copy the spec file to SPECS directory
cp "$SPEC_FILE" "$BUILD_DIR/SPECS/"

# Create or copy source tarball
if [ -d "snap7-full-${SNAP7_VERSION}" ]; then
    echo "Creating source tarball from snap7-full-${SNAP7_VERSION}..."
    tar czf "$BUILD_DIR/SOURCES/snap7-full-${SNAP7_VERSION}.tar.gz" snap7-full-${SNAP7_VERSION}/
elif [ -f "snap7-full-${SNAP7_VERSION}.tar.gz" ]; then
    echo "Using existing snap7-full-${SNAP7_VERSION}.tar.gz..."
    cp "snap7-full-${SNAP7_VERSION}.tar.gz" "$BUILD_DIR/SOURCES/"
else
    echo "Error: Cannot find snap7-full-${SNAP7_VERSION} directory or tarball!"
    exit 1
fi

# Build the RPM package
# Build for native architecture (can be modified to cross-compile)
rpmbuild \
    --define "_topdir $BUILD_DIR" \
    -ba "$BUILD_DIR/SPECS/$SPEC_FILE"

# Check build results
if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "Build successful!"
    echo ""
    echo "RPM packages created:"
    find "$BUILD_DIR/RPMS" -name "*.rpm" -type f
    echo ""
    echo "Source RPM created:"
    find "$BUILD_DIR/SRPMS" -name "*.rpm" -type f
    echo ""
    echo "To install the package, use:"
    echo "  sudo rpm -ivh <path-to-rpm>"
    echo ""
    echo "To upgrade an existing installation:"
    echo "  sudo rpm -Uvh <path-to-rpm>"
    echo ""
    echo "=========================================="
else
    echo "Build failed! Check the output above for errors."
    exit 1
fi
