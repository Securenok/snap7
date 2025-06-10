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
