#!/bin/bash
set -e

SRC_DIR="/media/sf_snap7/snap7-full-1.4.2/build/bin"
HEADERS_DIR="/media/sf_snap7/snap7-full-1.4.2/release"

for ARCH in i386-linux x86_64-linux; do
    case $ARCH in
        i386-linux)   DEB_ARCH="i386" ;;
        x86_64-linux) DEB_ARCH="amd64" ;;
    esac

    PKG_DIR="/tmp/libsnap7-securenok-${DEB_ARCH}"
    rm -rf "$PKG_DIR"
    mkdir -p "$PKG_DIR/DEBIAN"
    mkdir -p "$PKG_DIR/usr/lib"
    mkdir -p "$PKG_DIR/usr/include/snap7"

    # Copy the library and rename it
    cp "${SRC_DIR}/${ARCH}/libsnap7.so" "$PKG_DIR/usr/lib/libsnap7-securenok.so"
    chmod 755 "$PKG_DIR/usr/lib/libsnap7-securenok.so"

    # Copy headers
    cp -r "${HEADERS_DIR}"/* "$PKG_DIR/usr/include/snap7/"
    chmod -R a+r "$PKG_DIR/usr/include/snap7"
    chmod 755 "$PKG_DIR/usr/include/snap7"

    # Create control file
    cat > "$PKG_DIR/DEBIAN/control" <<EOF
Package: libsnap7-securenok
Version: 1.4.2-securenok
Section: libs
Priority: optional
Architecture: ${DEB_ARCH}
Depends: libc6 (>= 2.27)
Maintainer: Secure-NOK AS <support@securenok.com>
Description: Modified Snap7 library from Securenok fork
 A custom version of Snap7 installed as libsnap7-securenok.
EOF

    chmod 644 "$PKG_DIR/DEBIAN/control"

    # Create preinst script to remove existing library if present
    cat > "$PKG_DIR/DEBIAN/preinst" <<'EOF'
#!/bin/bash
set -e

LIB_PATH="/usr/lib/libsnap7-securenok.so"

if [ -f "$LIB_PATH" ]; then
    echo "Removing existing $LIB_PATH before upgrade"
    rm -f "$LIB_PATH"
fi

exit 0
EOF

    chmod 755 "$PKG_DIR/DEBIAN/preinst"

    # Create postinst script to fix permissions
    cat > "$PKG_DIR/DEBIAN/postinst" <<'EOF'
#!/bin/bash
set -e

LIB_PATH="/usr/lib/libsnap7-securenok.so"

# Fix library permissions
chmod 755 "$LIB_PATH"

# Ensure headers are readable
chmod -R a+r /usr/include/snap7
chmod a+x /usr/include/snap7

exit 0
EOF

    chmod 755 "$PKG_DIR/DEBIAN/postinst"

    # Build the .deb package
    dpkg-deb --build "$PKG_DIR"
done

echo "Done! Packages are in /tmp/snap7-securenok-i386.deb and /tmp/snap7-securenok-amd64.deb"
