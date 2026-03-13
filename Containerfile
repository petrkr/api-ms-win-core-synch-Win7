FROM fedora:latest AS build32

RUN dnf -y install \
    mingw32-gcc \
    mingw32-gcc-c++ \
    mingw32-filesystem \
    mingw32-winpthreads \
    mingw32-winpthreads-static \
    mingw32-headers \
    mingw32-crt \
    mingw32-binutils \
    cmake \
    make \
    && dnf clean all

WORKDIR /src
COPY . /src

RUN cmake -S . -B build32 \
    -DCMAKE_SYSTEM_NAME=Windows \
    -DCMAKE_C_COMPILER=i686-w64-mingw32-gcc \
    -DCMAKE_CXX_COMPILER=i686-w64-mingw32-g++ \
    -DCMAKE_RC_COMPILER=i686-w64-mingw32-windres \
    -DCMAKE_SYSROOT=/usr/i686-w64-mingw32/sys-root \
    -DCMAKE_FIND_ROOT_PATH=/usr/i686-w64-mingw32/sys-root \
    -DCMAKE_C_FLAGS=--sysroot=/usr/i686-w64-mingw32/sys-root \
    -DCMAKE_CXX_FLAGS=--sysroot=/usr/i686-w64-mingw32/sys-root \
    -DCMAKE_BUILD_TYPE=Release

RUN cmake --build build32 --config Release
RUN i686-w64-mingw32-strip --strip-unneeded build32/*.dll

FROM fedora:latest AS build64

RUN dnf -y install \
    mingw64-gcc \
    mingw64-gcc-c++ \
    mingw64-filesystem \
    mingw64-winpthreads \
    mingw64-winpthreads-static \
    mingw64-headers \
    mingw64-crt \
    mingw64-binutils \
    cmake \
    make \
    && dnf clean all

WORKDIR /src
COPY . /src

RUN cmake -S . -B build64 \
    -DCMAKE_SYSTEM_NAME=Windows \
    -DCMAKE_C_COMPILER=x86_64-w64-mingw32-gcc \
    -DCMAKE_CXX_COMPILER=x86_64-w64-mingw32-g++ \
    -DCMAKE_RC_COMPILER=x86_64-w64-mingw32-windres \
    -DCMAKE_SYSROOT=/usr/x86_64-w64-mingw32/sys-root \
    -DCMAKE_FIND_ROOT_PATH=/usr/x86_64-w64-mingw32/sys-root \
    -DCMAKE_C_FLAGS=--sysroot=/usr/x86_64-w64-mingw32/sys-root \
    -DCMAKE_CXX_FLAGS=--sysroot=/usr/x86_64-w64-mingw32/sys-root \
    -DCMAKE_BUILD_TYPE=Release

RUN cmake --build build64 --config Release
RUN x86_64-w64-mingw32-strip --strip-unneeded build64/*.dll

FROM scratch AS artifacts

COPY --from=build32 /src/build32/*.dll /x86/
COPY --from=build64 /src/build64/*.dll /x64/
