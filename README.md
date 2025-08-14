# snap7
- The snap7 library source file is downloaded from the official snap7 library's download link : https://sourceforge.net/projects/snap7/files/1.4.2/
- The last stable version release of snap 7 is **1.4.2** as mentioned in the [snap7 library's website](https://snap7.sourceforge.net/)

## Compile & Rebuid Instructions

For full instructions Refer to the **Rebuild Snap7** section of the official site : [snap7 library's website](https://snap7.sourceforge.net/)

**Build instruction for Linux x86/x64 :**
  - Open a terminal and go to build/unix :  
  ```sh
  cd snap7-full-1.4.2/build/unix
  ```
  - **To rebuild the library:**
    ```sh
    make -f x86_64_linux.mk all 
    ```
  - **To clean the project:**
    ```sh
    make -f x86_64_linux.mk clean 
    ```
  - **To rebuild and copy the library in 'usr/lib' (requires sudo permission):**
    ```sh
    make -f x86_64_linux.mk install 
    ```
  - In the folder **snap7-full-1.4.2/build/bin/x86_64-linux**  you will find **libsnap7.so**.


## Build instruction for Debian package
  - Make sure the above step of library build is done and the libraries are available in the folder  **snap7-full-1.4.2/build/bin/x86_64-linux**:  
 
  - Update the following values in the script `snap7/build_snap7_debs.sh` (Replace directory name `/media/sf_snap7/` with your directory name) :  
    ```sh
    SRC_DIR="/media/sf_snap7/snap7-full-1.4.2/build/bin"
    HEADERS_DIR="/media/sf_snap7/snap7-full-1.4.2/release"
    ```
  - **Run the script `snap7/build_snap7_debs.sh`**
    ```sh
    chmod +x build_snap7_debs.sh
    ./build_snap7_debs.sh
    ```
  - Two debian packages will be build and available at `/tmp/snap7-securenok-amd64.deb` and  `/tmp/snap7-securenok-i386.deb`
    
  - **To install the debian package**
    ```sh
    dpkg -i /tmp/snap7-securenok-amd64.deb 
    ```
    - This will install the custom snap7 library `snap7-securenok-amd64.deb` in the folder `/usr/lib`.
