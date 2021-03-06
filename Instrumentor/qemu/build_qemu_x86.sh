#!/bin/sh
#
# QEMU build script for Eclipser's instrumentation
#
# Modified codes from AFL's QEMU mode (original license below).
# --------------------------------------
#
# Written by Andrew Griffiths <agriffiths@google.com> and
#            Michal Zalewski <lcamtuf@google.com>
#
# Copyright 2015, 2016 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at:
#
#   http://www.apache.org/licenses/LICENSE-2.0

build_qemu () {
    echo "[*] Configuring QEMU for i386..."

    cd qemu-2.3.0-$1-x86 || exit 1

    CFLAGS="-O3" ./configure --disable-system --enable-linux-user \
      --python=python2 --enable-guest-base --disable-gtk --disable-sdl --disable-vnc \
      --target-list="i386-linux-user" || exit 1

    echo "[+] Configuration complete."

    echo "[*] Attempting to build QEMU (fingers crossed!)..."

    make || exit 1

    echo "[+] Build process successful!"

    echo "[*] Copying binary..."
    cp -f "i386-linux-user/qemu-i386" "../qemu-trace" || exit 1
    cd ..
}

### Build QEMU tracers

build_qemu pathcov
mv "./qemu-trace" "../../build/qemu-trace-pathcov-x86" || exit 1
echo "[+] Successfully created 'qemu-trace-pathcov-x86'."

build_qemu syscall
mv "./qemu-trace" "../../build/qemu-trace-syscall-x86" || exit 1
echo "[+] Successfully created 'qemu-trace-syscall-x86'."

build_qemu feedback
mv "./qemu-trace" "../../build/qemu-trace-feedback-x86" || exit 1
echo "[+] Successfully created 'qemu-trace-feedback-x86'."

build_qemu bbcount
mv "./qemu-trace" "../../build/qemu-trace-bbcount-x86" || exit 1
echo "[+] Successfully created 'qemu-trace-bbcount-x86'."

exit 0
