# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "/home/tomkys144/esp/esp-idf/components/bootloader/subproject"
  "/home/tomkys144/Documents/CTU/b241/LET/project/cmake-build-debug-esp-idf/bootloader"
  "/home/tomkys144/Documents/CTU/b241/LET/project/cmake-build-debug-esp-idf/bootloader-prefix"
  "/home/tomkys144/Documents/CTU/b241/LET/project/cmake-build-debug-esp-idf/bootloader-prefix/tmp"
  "/home/tomkys144/Documents/CTU/b241/LET/project/cmake-build-debug-esp-idf/bootloader-prefix/src/bootloader-stamp"
  "/home/tomkys144/Documents/CTU/b241/LET/project/cmake-build-debug-esp-idf/bootloader-prefix/src"
  "/home/tomkys144/Documents/CTU/b241/LET/project/cmake-build-debug-esp-idf/bootloader-prefix/src/bootloader-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "/home/tomkys144/Documents/CTU/b241/LET/project/cmake-build-debug-esp-idf/bootloader-prefix/src/bootloader-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "/home/tomkys144/Documents/CTU/b241/LET/project/cmake-build-debug-esp-idf/bootloader-prefix/src/bootloader-stamp${cfgdir}") # cfgdir has leading slash
endif()
